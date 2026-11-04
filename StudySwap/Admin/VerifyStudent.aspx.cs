using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace StudySwap.Admin
{
    public partial class VerifyStudent : System.Web.UI.Page
    {
        string cs = ConfigurationManager.ConnectionStrings["LIS"].ConnectionString;
        private const int PageSize = 15;

        private int CurrentPage
        {
            get { return ViewState["CurrentPage"] != null ? (int)ViewState["CurrentPage"] : 1; }
            set { ViewState["CurrentPage"] = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadColleges();
                CurrentPage = 1;
                LoadPendingStudents();
                UpdateStatistics();
            }
        }

        void LoadColleges()
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlDataAdapter da = new SqlDataAdapter(
                    "SELECT CollegeID, CollegeName FROM Colleges ORDER BY CollegeName", con);
                DataTable dt = new DataTable();
                da.Fill(dt);

                ddlFilterCollege.DataSource = dt;
                ddlFilterCollege.DataTextField = "CollegeName";
                ddlFilterCollege.DataValueField = "CollegeID";
                ddlFilterCollege.DataBind();
                ddlFilterCollege.Items.Insert(0, new ListItem("All Colleges", "0"));
            }
        }

        void LoadPendingStudents()
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                // Query to get ONLY pending students (IsVerified = 0 and Active)
                string baseQuery = @"
                    SELECT 
                        s.UserID,
                        s.FullName,
                        s.Email,
                        s.Phone,
                        c.CollegeName,
                        d.DepartmentName,
                        cr.CourseName,
                        s.RollNumber,
                        s.StudentIDProofPath
                    FROM Users s
                    INNER JOIN Colleges c ON s.College = c.CollegeID
                    INNER JOIN Departments d ON s.Department = d.DepartmentID
                    INNER JOIN Courses cr ON s.CourseID = cr.CourseID
                    WHERE s.IsVerified = 0 AND s.AccountStatus = 'Active'";

                string countQuery = @"
                    SELECT COUNT(*) 
                    FROM Users s
                    WHERE s.IsVerified = 0 AND s.AccountStatus = 'Active'";

                string whereClause = BuildWhereClause();
                baseQuery += whereClause;
                countQuery += whereClause;

                // Get total count
                SqlCommand countCmd = new SqlCommand(countQuery, con);
                AddParameters(countCmd);
                con.Open();
                int totalRecords = (int)countCmd.ExecuteScalar();

                // Calculate pagination
                int totalPages = (int)Math.Ceiling((double)totalRecords / PageSize);
                if (CurrentPage > totalPages && totalPages > 0) CurrentPage = totalPages;
                if (CurrentPage < 1) CurrentPage = 1;

                int offset = (CurrentPage - 1) * PageSize;

                // Add pagination
                baseQuery += " ORDER BY s.MemberSince DESC OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY";

                SqlCommand cmd = new SqlCommand(baseQuery, con);
                AddParameters(cmd);
                cmd.Parameters.AddWithValue("@Offset", offset);
                cmd.Parameters.AddWithValue("@PageSize", PageSize);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                con.Close();

                // Bind data
                rptStudents.DataSource = dt;
                rptStudents.DataBind();

                // Show/hide empty state
                pnlEmpty.Visible = (dt.Rows.Count == 0);

                // Update pagination
                if (totalRecords > 0)
                {
                    int startRecord = offset + 1;
                    int endRecord = Math.Min(offset + PageSize, totalRecords);
                    lblPageInfo.Text = $"Showing {startRecord}-{endRecord} of {totalRecords} pending student(s)";
                    UpdatePaginationControls(totalPages);
                }
                else
                {
                    lblPageInfo.Text = "No pending students";
                    pnlPagination.Visible = false;
                }
            }
        }

        string BuildWhereClause()
        {
            string whereClause = "";

            // College filter
            if (ddlFilterCollege.SelectedValue != "0")
            {
                whereClause += " AND s.College = @CollegeID";
            }

            // Search filter
            if (!string.IsNullOrEmpty(txtSearch.Text.Trim()))
            {
                whereClause += " AND (s.FullName LIKE @Search OR s.Email LIKE @Search OR s.RollNumber LIKE @Search)";
            }

            return whereClause;
        }

        void AddParameters(SqlCommand cmd)
        {
            if (ddlFilterCollege.SelectedValue != "0")
            {
                cmd.Parameters.AddWithValue("@CollegeID", ddlFilterCollege.SelectedValue);
            }

            if (!string.IsNullOrEmpty(txtSearch.Text.Trim()))
            {
                cmd.Parameters.AddWithValue("@Search", "%" + txtSearch.Text.Trim() + "%");
            }
        }

        void UpdatePaginationControls(int totalPages)
        {
            pnlPagination.Visible = totalPages > 1;

            btnFirstPage.Enabled = CurrentPage > 1;
            btnPrevPage.Enabled = CurrentPage > 1;
            btnNextPage.Enabled = CurrentPage < totalPages;
            btnLastPage.Enabled = CurrentPage < totalPages;

            litCurrentPage.Text = CurrentPage.ToString();
            litTotalPages.Text = totalPages.ToString();
        }

        void UpdateStatistics()
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                // Pending count
                SqlCommand cmdPending = new SqlCommand(
                    "SELECT COUNT(*) FROM Users WHERE IsVerified = 0 AND AccountStatus = 'Active'", con);
                int pendingCount = (int)cmdPending.ExecuteScalar();
                litPendingCount.Text = pendingCount.ToString();
                litPendingCount2.Text = pendingCount.ToString();

                // Verified count
                SqlCommand cmdVerified = new SqlCommand(
                    "SELECT COUNT(*) FROM Users WHERE IsVerified = 1", con);
                litVerifiedCount.Text = cmdVerified.ExecuteScalar().ToString();

                // Rejected count
                SqlCommand cmdRejected = new SqlCommand(
                    "SELECT COUNT(*) FROM Users WHERE AccountStatus = 'Rejected'", con);
                litRejectedCount.Text = cmdRejected.ExecuteScalar().ToString();
            }
        }

        protected void rptStudents_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int userId = Convert.ToInt32(e.CommandArgument);

            switch (e.CommandName)
            {
                case "Approve":
                    ApproveStudent(userId);
                    ShowMessage("✅ Student approved successfully!", "success");

                    // Register script to hide the student item
                    RegisterHideScript(userId);
                    break;

                case "Reject":
                    RejectStudent(userId);
                    ShowMessage("❌ Student rejected!", "warning");

                    // Register script to hide the student item
                    RegisterHideScript(userId);
                    break;
            }

            // Reload list after a short delay to show animation
            System.Threading.Thread.Sleep(100);
            LoadPendingStudents();
            UpdateStatistics();
        }

        void RegisterHideScript(int userId)
        {
            string script = $"hideStudent({userId});";
            ClientScript.RegisterStartupScript(this.GetType(), "hideStudent" + userId, script, true);
        }

        void ApproveStudent(int userId)
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand(
                    @"UPDATE Users 
                      SET IsVerified = 1,
                          AccountStatus = 'Active',
                          VerificationDate = GETDATE()
                      WHERE UserID = @UserID", con);
                cmd.Parameters.AddWithValue("@UserID", userId);
                con.Open();
                cmd.ExecuteNonQuery();
            }

            // TODO: Send approval email
            // SendApprovalEmail(userId);
        }

        void RejectStudent(int userId)
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand(
                    @"UPDATE Users 
                      SET IsVerified = 0,
                          AccountStatus = 'Rejected'
                      WHERE UserID = @UserID", con);
                cmd.Parameters.AddWithValue("@UserID", userId);
                con.Open();
                cmd.ExecuteNonQuery();
            }

            // TODO: Send rejection email
            // SendRejectionEmail(userId);
        }

        void ShowMessage(string message, string type)
        {
            pnlMessage.Visible = true;
            litMessage.Text = message;

            if (type == "success")
            {
                litMessageIcon.Text = "✓";
                pnlMessage.CssClass = "alert-box alert-success";
            }
            else if (type == "error")
            {
                litMessageIcon.Text = "✗";
                pnlMessage.CssClass = "alert-box alert-error";
            }
            else if (type == "warning")
            {
                litMessageIcon.Text = "⚠";
                pnlMessage.CssClass = "alert-box alert-warning";
            }
        }

        protected void txtSearch_TextChanged(object sender, EventArgs e)
        {
            CurrentPage = 1;
            LoadPendingStudents();
        }

        protected void ddlFilterCollege_SelectedIndexChanged(object sender, EventArgs e)
        {
            CurrentPage = 1;
            LoadPendingStudents();
        }

        protected void btnRefresh_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            ddlFilterCollege.SelectedIndex = 0;
            CurrentPage = 1;
            LoadPendingStudents();
            UpdateStatistics();
        }

        // Pagination handlers
        protected void btnFirstPage_Click(object sender, EventArgs e)
        {
            CurrentPage = 1;
            LoadPendingStudents();
        }

        protected void btnPrevPage_Click(object sender, EventArgs e)
        {
            if (CurrentPage > 1)
            {
                CurrentPage--;
                LoadPendingStudents();
            }
        }

        protected void btnNextPage_Click(object sender, EventArgs e)
        {
            CurrentPage++;
            LoadPendingStudents();
        }

        protected void btnLastPage_Click(object sender, EventArgs e)
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                string countQuery = @"SELECT COUNT(*) 
                    FROM Users s
                    WHERE s.IsVerified = 0 AND s.AccountStatus = 'Active'" + BuildWhereClause();

                SqlCommand cmd = new SqlCommand(countQuery, con);
                AddParameters(cmd);
                con.Open();
                int totalRecords = (int)cmd.ExecuteScalar();
                CurrentPage = (int)Math.Ceiling((double)totalRecords / PageSize);
            }
            LoadPendingStudents();
        }

        // Helper method
        public string GetInitials(string fullName)
        {
            if (string.IsNullOrEmpty(fullName)) return "??";

            var names = fullName.Split(' ');
            if (names.Length >= 2)
                return (names[0][0].ToString() + names[1][0].ToString()).ToUpper();
            else
                return fullName.Substring(0, Math.Min(2, fullName.Length)).ToUpper();
        }
    }
}