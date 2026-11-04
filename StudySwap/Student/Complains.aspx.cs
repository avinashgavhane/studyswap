using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace StudySwap.Student
{
    public partial class Complains : System.Web.UI.Page
    {
        private string ConnStr =>
            ConfigurationManager.ConnectionStrings["LIS"].ConnectionString;

        // Logged-in student's UserID (from session)
        private int CurrentUserID
        {
            get
            {
                if (Session["UserID"] == null) return 0;
                return Convert.ToInt32(Session["UserID"]);
            }
        }

        private int EditingComplaintID
        {
            get { return ViewState["EditingComplaintID"] == null ? 0 : (int)ViewState["EditingComplaintID"]; }
            set { ViewState["EditingComplaintID"] = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (CurrentUserID == 0)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                BindComplaints();
                SetAddMode();
            }
        }

        #region Mode helpers

        private void SetAddMode()
        {
            EditingComplaintID = 0;
            hfComplaintID.Value = "0";
            litFormTitle.Text = "Raise a Complaint";
            btnSave.Text = "Submit Complaint";
            btnCancel.Visible = false;
            ClearFields();
        }

        private void SetEditMode(int complaintId)
        {
            EditingComplaintID = complaintId;
            hfComplaintID.Value = complaintId.ToString();
            litFormTitle.Text = "Edit Complaint #" + complaintId;
            btnSave.Text = "Update Complaint";
            btnCancel.Visible = true;
        }

        #endregion

        #region Bind grid

        private void BindComplaints()
        {
            using (SqlConnection con = new SqlConnection(ConnStr))
            {
                string q = @"
                    SELECT TOP (1000)
                           c.[ComplaintID], c.[Category], c.[Subject], c.[Description],
                           c.[Priority], c.[Status], c.[AdminResponse],
                           c.[ResolvedDate], c.[CreatedDate]
                      FROM [StudySwap].[dbo].[Complaints] c
                     WHERE c.[UserID] = @uid
                     ORDER BY c.[ComplaintID] DESC";

                using (SqlDataAdapter da = new SqlDataAdapter(q, con))
                {
                    da.SelectCommand.Parameters.AddWithValue("@uid", CurrentUserID);
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    gvComplaints.DataSource = dt;
                    gvComplaints.DataBind();
                }
            }
        }

        #endregion

        #region Helpers (used from markup)

        public string GetStatusBadgeClass(object status)
        {
            string s = (status ?? "").ToString().ToLower().Replace(" ", "");
            switch (s)
            {
                case "pending": return "badge badge-open";
                case "inprogress": return "badge badge-inprogress";
                case "completed": return "badge badge-resolved";
                case "rejected": return "badge badge-rejected";
                default: return "badge badge-open";
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

        // Student can edit only while complaint is still 'Pending'
        public bool CanEdit(object status)
        {
            string s = (status ?? "").ToString();
            return s.Equals("Pending", StringComparison.OrdinalIgnoreCase);
        }

        // Student can delete only 'Pending' or 'Rejected' complaints
        public bool CanDelete(object status)
        {
            string s = (status ?? "").ToString();
            return s.Equals("Pending", StringComparison.OrdinalIgnoreCase)
                || s.Equals("Rejected", StringComparison.OrdinalIgnoreCase);
        }

        #endregion

        #region Save / Update

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(ddlCategory.SelectedValue))
            {
                lblMsg.ForeColor = System.Drawing.Color.Red;
                lblMsg.Text = "Please select a category.";
                return;
            }
            if (string.IsNullOrWhiteSpace(txtSubject.Text))
            {
                lblMsg.ForeColor = System.Drawing.Color.Red;
                lblMsg.Text = "Subject is required.";
                return;
            }
            if (string.IsNullOrWhiteSpace(txtDescription.Text))
            {
                lblMsg.ForeColor = System.Drawing.Color.Red;
                lblMsg.Text = "Description is required.";
                return;
            }

            try
            {
                if (EditingComplaintID > 0)
                    UpdateComplaint(EditingComplaintID);
                else
                    InsertComplaint();

                BindComplaints();
                SetAddMode();

                lblMsg.ForeColor = System.Drawing.Color.Green;
                lblMsg.Text = "Saved successfully!";
            }
            catch (Exception ex)
            {
                lblMsg.ForeColor = System.Drawing.Color.Red;
                lblMsg.Text = "Error: " + ex.Message;
            }
        }

        private void InsertComplaint()
        {
            using (SqlConnection con = new SqlConnection(ConnStr))
            {
                string q = @"
                    INSERT INTO [StudySwap].[dbo].[Complaints]
                        ([UserID],[Category],[Subject],[Description],
                         [Priority],[Status],[CreatedDate],[LastModified])
                    VALUES
                        (@UserID,@Category,@Subject,@Description,
                         @Priority,'Pending',GETDATE(),GETDATE())";   // ← 'Pending' (allowed)

                using (SqlCommand cmd = new SqlCommand(q, con))
                {
                    cmd.Parameters.AddWithValue("@UserID", CurrentUserID);
                    cmd.Parameters.AddWithValue("@Category", ddlCategory.SelectedValue);
                    cmd.Parameters.AddWithValue("@Subject", txtSubject.Text.Trim());
                    cmd.Parameters.AddWithValue("@Description", txtDescription.Text.Trim());
                    cmd.Parameters.AddWithValue("@Priority", ddlPriority.SelectedValue);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        private void UpdateComplaint(int complaintId)
        {
            using (SqlConnection con = new SqlConnection(ConnStr))
            {
                string q = @"
                    UPDATE [StudySwap].[dbo].[Complaints]
                       SET [Category]     = @Category,
                           [Subject]      = @Subject,
                           [Description]  = @Description,
                           [Priority]     = @Priority,
                           [LastModified] = GETDATE()
                     WHERE [ComplaintID]  = @ComplaintID
                       AND [UserID]       = @UserID
                       AND [Status]       = 'Pending'";   // ← 'Pending' (allowed)

                using (SqlCommand cmd = new SqlCommand(q, con))
                {
                    cmd.Parameters.AddWithValue("@Category", ddlCategory.SelectedValue);
                    cmd.Parameters.AddWithValue("@Subject", txtSubject.Text.Trim());
                    cmd.Parameters.AddWithValue("@Description", txtDescription.Text.Trim());
                    cmd.Parameters.AddWithValue("@Priority", ddlPriority.SelectedValue);
                    cmd.Parameters.AddWithValue("@ComplaintID", complaintId);
                    cmd.Parameters.AddWithValue("@UserID", CurrentUserID);

                    con.Open();
                    int rows = cmd.ExecuteNonQuery();
                    if (rows == 0)
                        throw new Exception("This complaint can no longer be edited (it may already be in progress, completed, or rejected).");
                }
            }
        }

        #endregion

        #region Cancel / Clear

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            SetAddMode();
            lblMsg.Text = string.Empty;
        }

        private void ClearFields()
        {
            ddlCategory.SelectedIndex = 0;
            txtSubject.Text = string.Empty;
            txtDescription.Text = string.Empty;
            ddlPriority.SelectedValue = "Medium";
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
            if (e.CommandName == "EditComplaint")
            {
                int complaintId = Convert.ToInt32(e.CommandArgument);
                LoadComplaintIntoForm(complaintId);
                SetEditMode(complaintId);

                lblMsg.ForeColor = System.Drawing.Color.DarkOrange;
                lblMsg.Text = "Editing Complaint #" + complaintId + ". Change and click Update.";
            }
        }

        private void LoadComplaintIntoForm(int complaintId)
        {
            using (SqlConnection con = new SqlConnection(ConnStr))
            {
                string q = @"
                    SELECT [ComplaintID],[Category],[Subject],[Description],[Priority],[Status]
                      FROM [StudySwap].[dbo].[Complaints]
                     WHERE [ComplaintID] = @ComplaintID
                       AND [UserID]      = @UserID";

                using (SqlCommand cmd = new SqlCommand(q, con))
                {
                    cmd.Parameters.AddWithValue("@ComplaintID", complaintId);
                    cmd.Parameters.AddWithValue("@UserID", CurrentUserID);
                    con.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            SetDropdown(ddlCategory, dr["Category"].ToString());
                            txtSubject.Text = dr["Subject"] as string ?? "";
                            txtDescription.Text = dr["Description"] as string ?? "";
                            SetDropdown(ddlPriority, dr["Priority"].ToString());
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

        protected void gvComplaints_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int complaintId = Convert.ToInt32(gvComplaints.DataKeys[e.RowIndex].Value);

            try
            {
                using (SqlConnection con = new SqlConnection(ConnStr))
                {
                    string q = @"
                        DELETE FROM [StudySwap].[dbo].[Complaints]
                         WHERE [ComplaintID] = @ComplaintID
                           AND [UserID]      = @UserID
                           AND [Status]      IN ('Pending','Rejected')";   // ← allowed values

                    using (SqlCommand cmd = new SqlCommand(q, con))
                    {
                        cmd.Parameters.AddWithValue("@ComplaintID", complaintId);
                        cmd.Parameters.AddWithValue("@UserID", CurrentUserID);
                        con.Open();
                        int rows = cmd.ExecuteNonQuery();
                        if (rows == 0)
                            throw new Exception("This complaint can no longer be deleted.");
                    }
                }

                if (EditingComplaintID == complaintId)
                    SetAddMode();

                BindComplaints();
                lblMsg.ForeColor = System.Drawing.Color.Green;
                lblMsg.Text = "Complaint deleted successfully.";
            }
            catch (Exception ex)
            {
                lblMsg.ForeColor = System.Drawing.Color.Red;
                lblMsg.Text = "Delete failed: " + ex.Message;
            }
        }

        #endregion
    }
}