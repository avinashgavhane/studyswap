using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace StudySwap.Admin
{
    public partial class ViewComplaints : System.Web.UI.Page
    {
        private string ConnStr =>
            ConfigurationManager.ConnectionStrings["LIS"].ConnectionString;

        // Logged-in admin's UserID (for ResolvedBy)
        private int CurrentAdminID
        {
            get
            {
                if (Session["UserID"] == null) return 0;
                return Convert.ToInt32(Session["UserID"]);
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindComplaints();
            }
        }

        #region Bind grid

        private void BindComplaints()
        {
            string search = txtSearch.Text.Trim();
            string status = ddlStatusFilter.SelectedValue;
            string category = ddlCategoryFilter.SelectedValue;
            string priority = ddlPriorityFilter.SelectedValue;

            string q = @"
                SELECT TOP (1000)
                       c.[ComplaintID], c.[Category], c.[Subject], c.[Description],
                       c.[Priority], c.[Status], c.[AdminResponse],
                       c.[ResolvedDate], c.[CreatedDate],
                       u.[FullName] AS StudentName,
                       u.[Email]    AS StudentEmail
                  FROM [dbo].[Complaints] c
                  LEFT JOIN [dbo].[Users] u ON c.[UserID] = u.[UserID]
                 WHERE 1 = 1";

            if (!string.IsNullOrEmpty(search))
                q += " AND (c.[Subject] LIKE @q OR c.[Description] LIKE @q OR u.[FullName] LIKE @q)";
            if (!string.IsNullOrEmpty(status))
                q += " AND c.[Status] = @status";
            if (!string.IsNullOrEmpty(category))
                q += " AND c.[Category] = @category";
            if (!string.IsNullOrEmpty(priority))
                q += " AND c.[Priority] = @priority";

            q += " ORDER BY c.[ComplaintID] DESC";

            using (SqlConnection con = new SqlConnection(ConnStr))
            using (SqlCommand cmd = new SqlCommand(q, con))
            {
                if (!string.IsNullOrEmpty(search))
                    cmd.Parameters.AddWithValue("@q", "%" + search + "%");
                if (!string.IsNullOrEmpty(status))
                    cmd.Parameters.AddWithValue("@status", status);
                if (!string.IsNullOrEmpty(category))
                    cmd.Parameters.AddWithValue("@category", category);
                if (!string.IsNullOrEmpty(priority))
                    cmd.Parameters.AddWithValue("@priority", priority);

                using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    gvComplaints.DataSource = dt;
                    gvComplaints.DataBind();
                }
            }
        }

        #endregion

        #region Helpers (used in markup)

        public string GetStatusBadgeClass(object status)
        {
            string s = (status ?? "").ToString().ToLower();
            switch (s)
            {
                case "pending": return "badge badge-pending";
                case "in progress": return "badge badge-inprogress";
                case "completed": return "badge badge-completed";
                case "rejected": return "badge badge-rejected";
                default: return "badge badge-pending";
            }
        }

        public string GetPriorityClass(object priority)
        {
            string p = (priority ?? "").ToString().ToLower();
            switch (p)
            {
                case "low": return "prio prio-low";
                case "medium": return "prio prio-medium";
                case "high": return "prio prio-high";
                case "urgent": return "prio prio-urgent";
                default: return "prio prio-medium";
            }
        }

        #endregion

        #region Filter

        protected void btnFilter_Click(object sender, EventArgs e)
        {
            gvComplaints.PageIndex = 0;
            BindComplaints();
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            ddlStatusFilter.SelectedIndex = 0;
            ddlCategoryFilter.SelectedIndex = 0;
            ddlPriorityFilter.SelectedIndex = 0;
            gvComplaints.PageIndex = 0;
            BindComplaints();
        }

        #endregion

        #region GridView events

        protected void gvComplaints_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvComplaints.PageIndex = e.NewPageIndex;
            BindComplaints();
        }

        protected void gvComplaints_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "UpdateStatus")
            {
                int complaintId = Convert.ToInt32(e.CommandArgument);
                LoadComplaintIntoModal(complaintId);
                ClientScript.RegisterStartupScript(this.GetType(), "openModal",
                    "openStatusModal();", true);
            }
        }

        private void LoadComplaintIntoModal(int complaintId)
        {
            using (SqlConnection con = new SqlConnection(ConnStr))
            {
                string q = @"
                    SELECT c.[ComplaintID], c.[Category], c.[Subject], c.[Description],
                           c.[Priority], c.[Status], c.[AdminResponse],
                           u.[FullName] AS StudentName, u.[Email] AS StudentEmail
                      FROM [dbo].[Complaints] c
                      LEFT JOIN [dbo].[Users] u ON c.[UserID] = u.[UserID]
                     WHERE c.[ComplaintID] = @ComplaintID";

                using (SqlCommand cmd = new SqlCommand(q, con))
                {
                    cmd.Parameters.AddWithValue("@ComplaintID", complaintId);
                    con.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            hfComplaintID.Value = dr["ComplaintID"].ToString();
                            litInfoId.Text = dr["ComplaintID"].ToString();
                            litInfoStudent.Text = (dr["StudentName"] as string ?? "(unknown)")
                                                   + " <" + (dr["StudentEmail"] as string ?? "") + ">";
                            litInfoCategory.Text = dr["Category"].ToString();
                            litInfoSubject.Text = dr["Subject"].ToString();
                            litInfoDesc.Text = dr["Description"].ToString();

                            SetDropdown(ddlNewStatus, dr["Status"].ToString());
                            txtAdminResponse.Text = dr["AdminResponse"] as string ?? "";
                        }
                    }
                }
            }
        }

        private void SetDropdown(DropDownList ddl, string value)
        {
            if (string.IsNullOrEmpty(value)) return;
            ListItem item = ddl.Items.FindByValue(value);
            if (item != null)
            {
                ddl.ClearSelection();
                item.Selected = true;
            }
        }

        #endregion

        #region Update status

        protected void btnSaveStatus_Click(object sender, EventArgs e)
        {
            int complaintId = 0;
            int.TryParse(hfComplaintID.Value, out complaintId);

            if (complaintId <= 0)
            {
                lblMsg.ForeColor = System.Drawing.Color.Red;
                lblMsg.Text = "Invalid complaint. Please reopen the update dialog.";
                return;
            }

            string newStatus = ddlNewStatus.SelectedValue;
            string response = txtAdminResponse.Text.Trim();

            try
            {
                using (SqlConnection con = new SqlConnection(ConnStr))
                {
                    bool complete = newStatus.Equals("Completed", StringComparison.OrdinalIgnoreCase);

                    string q = @"
                        UPDATE [dbo].[Complaints]
                           SET [Status]        = @Status,
                               [AdminResponse] = @AdminResponse,
                               [ResolvedBy]    = CASE WHEN @Complete = 1 THEN @AdminID ELSE [ResolvedBy] END,
                               [ResolvedDate]  = CASE WHEN @Complete = 1 THEN GETDATE() ELSE [ResolvedDate] END,
                               [LastModified]  = GETDATE()
                         WHERE [ComplaintID]   = @ComplaintID";

                    using (SqlCommand cmd = new SqlCommand(q, con))
                    {
                        cmd.Parameters.AddWithValue("@Status", newStatus);
                        cmd.Parameters.AddWithValue("@AdminResponse",
                            string.IsNullOrEmpty(response) ? (object)DBNull.Value : response);
                        cmd.Parameters.AddWithValue("@Complete", complete ? 1 : 0);
                        cmd.Parameters.AddWithValue("@AdminID",
                            CurrentAdminID > 0 ? (object)CurrentAdminID : DBNull.Value);
                        cmd.Parameters.AddWithValue("@ComplaintID", complaintId);

                        con.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                BindComplaints();
                lblMsg.ForeColor = System.Drawing.Color.Green;
                lblMsg.Text = "Complaint #" + complaintId + " updated successfully.";
                ClientScript.RegisterStartupScript(this.GetType(), "closeModal",
                    "closeStatusModal();", true);
            }
            catch (Exception ex)
            {
                lblMsg.ForeColor = System.Drawing.Color.Red;
                lblMsg.Text = "Update failed: " + ex.Message;
                ClientScript.RegisterStartupScript(this.GetType(), "openModal",
                    "openStatusModal();", true);
            }
        }

        protected void btnCancelStatus_Click(object sender, EventArgs e)
        {
            ClientScript.RegisterStartupScript(this.GetType(), "closeModal",
                "closeStatusModal();", true);
        }

        #endregion
    }
}