using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace StudySwap.Admin
{
    public partial class AdminDashboard : System.Web.UI.Page
    {
        // Change this connection string name to match your Web.config entry
        private readonly string _connStr =
            ConfigurationManager.ConnectionStrings["LIS"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadDashboardStats();
                LoadAdminName();
                LoadRecentActivity();
            }
        }

        /// <summary>
        /// Populates the four stat cards.
        /// </summary>
        private void LoadDashboardStats()
        {
            using (SqlConnection con = new SqlConnection(_connStr))
            {
                con.Open();

                // 1. Total Students (users with role 'Student')
                lblTotalStudents.Text = ExecuteScalarCount(con,
                    "SELECT COUNT(*) FROM Users WHERE UserRole = 'Student'");

                // 2. Active Listings
                lblActiveListings.Text = ExecuteScalarCount(con,
                    "SELECT COUNT(*) FROM Listings WHERE Status = 'Active'");

                // 3. Pending Verifications (unverified students)
                lblPendingVerifications.Text = ExecuteScalarCount(con,
                    "SELECT COUNT(*) FROM Users WHERE UserRole = 'Student' AND IsVerified = 0");

                // 4. New Complaints (Status = 'Pending')
                lblNewComplaints.Text = ExecuteScalarCount(con,
                    "SELECT COUNT(*) FROM Complaints WHERE Status = 'Pending'");
            }
        }

        /// <summary>
        /// Helper that runs a COUNT query and returns the number as a string.
        /// </summary>
        private string ExecuteScalarCount(SqlConnection con, string query)
        {
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                object result = cmd.ExecuteScalar();
                int count = (result == null || result == DBNull.Value) ? 0 : Convert.ToInt32(result);
                return count.ToString();
            }
        }

        /// <summary>
        /// Loads the admin display name from session, falls back to "Admin".
        /// </summary>
        private void LoadAdminName()
        {
            string adminName = Session["AdminName"] as string;
            if (string.IsNullOrWhiteSpace(adminName))
            {
                adminName = Session["AdminEmail"] as string;
            }
            if (string.IsNullOrWhiteSpace(adminName))
            {
                adminName = "Admin";
            }

            lblAdminNameDashboard.Text = adminName;
        }

        /// <summary>
        /// Shows the 5 most recent listings + complaints as "recent activity".
        /// </summary>
        private void LoadRecentActivity()
        {
            System.Text.StringBuilder sb = new System.Text.StringBuilder();

            using (SqlConnection con = new SqlConnection(_connStr))
            {
                con.Open();

                // Recent listings
                string listingQuery = @"
                    SELECT TOP 5 l.Title, l.PostedDate, u.FullName
                    FROM Listings l
                    INNER JOIN Users u ON u.UserID = l.UserID
                    ORDER BY l.PostedDate DESC";

                using (SqlCommand cmd = new SqlCommand(listingQuery, con))
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    bool hasListings = false;
                    while (dr.Read())
                    {
                        if (!hasListings)
                        {
                            sb.Append("<h6 class='text-primary mt-2'>Latest Listings</h6><ul class='list-group list-group-flush mb-3'>");
                            hasListings = true;
                        }

                        string title = dr["Title"].ToString();
                        string user = dr["FullName"].ToString();
                        DateTime posted = Convert.ToDateTime(dr["PostedDate"]);

                        sb.AppendFormat(
                            "<li class='list-group-item d-flex justify-content-between align-items-center'>" +
                            "<span><i class='fas fa-box text-success me-2'></i>{0} <small class='text-muted'>by {1}</small></span>" +
                            "<small class='text-muted'>{2:dd MMM yyyy HH:mm}</small></li>",
                            System.Web.HttpUtility.HtmlEncode(title),
                            System.Web.HttpUtility.HtmlEncode(user),
                            posted);
                    }
                    if (hasListings) sb.Append("</ul>");
                }

                // Recent complaints
                string complaintQuery = @"
                    SELECT TOP 5 c.Subject, c.Status, c.CreatedDate, u.FullName
                    FROM Complaints c
                    INNER JOIN Users u ON u.UserID = c.UserID
                    ORDER BY c.CreatedDate DESC";

                using (SqlCommand cmd = new SqlCommand(complaintQuery, con))
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    bool hasComplaints = false;
                    while (dr.Read())
                    {
                        if (!hasComplaints)
                        {
                            sb.Append("<h6 class='text-danger mt-2'>Latest Complaints</h6><ul class='list-group list-group-flush'>");
                            hasComplaints = true;
                        }

                        string subject = dr["Subject"].ToString();
                        string status = dr["Status"].ToString();
                        string user = dr["FullName"].ToString();
                        DateTime created = Convert.ToDateTime(dr["CreatedDate"]);

                        string badgeClass =
                            status == "Pending" ? "bg-warning text-dark" :
                            status == "In Progress" ? "bg-info text-dark" :
                            status == "Completed" ? "bg-success" :
                            status == "Rejected" ? "bg-danger" : "bg-secondary";

                        sb.AppendFormat(
                            "<li class='list-group-item d-flex justify-content-between align-items-center'>" +
                            "<span><i class='fas fa-comment-dots text-danger me-2'></i>{0} <small class='text-muted'>by {1}</small></span>" +
                            "<span><span class='badge {2} me-2'>{3}</span><small class='text-muted'>{4:dd MMM yyyy}</small></span></li>",
                            System.Web.HttpUtility.HtmlEncode(subject),
                            System.Web.HttpUtility.HtmlEncode(user),
                            badgeClass,
                            System.Web.HttpUtility.HtmlEncode(status),
                            created);
                    }
                    if (hasComplaints) sb.Append("</ul>");
                }
            }

            litRecentActivity.Text = sb.Length > 0
                ? sb.ToString()
                : "<p class='text-muted'>No recent activity to display.</p>";
        }
    }
}