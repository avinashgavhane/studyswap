using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace StudySwap.Student
{
    public partial class StudentDashboard : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["LIS"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadStudentName();
                LoadDashboardStats();
                LoadMyListings();
                LoadRecentPayments();
                LoadRecentComplaints();
                LoadRecentActivity();
                LoadReplyNotifications();
            }
        }

        // ============================================
        // LOAD STUDENT NAME
        // ============================================
        private void LoadStudentName()
        {
            int studentId = Convert.ToInt32(Session["UserID"]);

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT FullName FROM Users WHERE UserID = @StudentID";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@StudentID", studentId);
                    con.Open();
                    var result = cmd.ExecuteScalar();
                    if (result != null)
                        lblStudentName.Text = result.ToString();
                }
            }
        }

        // ============================================
        // LOAD DASHBOARD STATS
        // ============================================
        private void LoadDashboardStats()
        {
            int studentId = Convert.ToInt32(Session["UserID"]);

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();

                // 1. Active Listings
                try
                {
                    using (SqlCommand cmd = new SqlCommand(
                        "SELECT COUNT(*) FROM Listings WHERE UserID = @StudentID AND Status = 'Active'", con))
                    {
                        cmd.Parameters.AddWithValue("@StudentID", studentId);
                        lblActiveListings.Text = cmd.ExecuteScalar()?.ToString() ?? "0";
                    }
                }
                catch { lblActiveListings.Text = "0"; }

                // 2. New Listings this week
                try
                {
                    using (SqlCommand cmd = new SqlCommand(
                        @"SELECT COUNT(*) FROM Listings 
                  WHERE UserID = @StudentID 
                    AND PostedDate > DATEADD(DAY, -7, GETDATE())", con))
                    {
                        cmd.Parameters.AddWithValue("@StudentID", studentId);
                        lblNewListingsWeek.Text = cmd.ExecuteScalar()?.ToString() ?? "0";
                    }
                }
                catch { lblNewListingsWeek.Text = "0"; }

                // 3. My Purchases
                try
                {
                    using (SqlCommand cmd = new SqlCommand(
                        @"SELECT COUNT(*) FROM Payments 
                  WHERE PayerUserID = @StudentID 
                    AND PaymentStatus IN ('Completed','Success')", con))
                    {
                        cmd.Parameters.AddWithValue("@StudentID", studentId);
                        lblMyPurchases.Text = cmd.ExecuteScalar()?.ToString() ?? "0";
                    }
                }
                catch { lblMyPurchases.Text = "0"; }

                // 4. Total Earnings
                try
                {
                    using (SqlCommand cmd = new SqlCommand(
                        @"SELECT ISNULL(SUM(p.Amount), 0) 
                  FROM Payments p
                  INNER JOIN Listings l ON p.ListingID = l.ListingID
                  WHERE l.UserID = @StudentID 
                    AND p.PaymentStatus IN ('Completed','Success')
                    AND p.PayerUserID <> @StudentID", con))
                    {
                        cmd.Parameters.AddWithValue("@StudentID", studentId);
                        decimal total = Convert.ToDecimal(cmd.ExecuteScalar());
                        lblTotalEarnings.Text = total.ToString("N0");
                    }
                }
                catch { lblTotalEarnings.Text = "0"; }

                // 5. My Complaints count — OPEN (Pending + In Progress)
                
                    using (SqlCommand cmd = new SqlCommand(
                        @"SELECT COUNT(*) FROM Complaints 
                  WHERE UserID = @StudentID 
                    AND Status IN ('Pending','In Progress','Completed','Rejected')", con))
                    {
                        cmd.Parameters.AddWithValue("@StudentID", studentId);
                        lblMyComplaints.Text = cmd.ExecuteScalar()?.ToString() ?? "0";
                    }
                

                // 6. Pending Complaints (only literal 'Pending')
                try
                {
                    using (SqlCommand cmd = new SqlCommand(
                        @"SELECT COUNT(*) FROM Complaints 
                  WHERE UserID = @StudentID AND Status = 'Pending'", con))
                    {
                        cmd.Parameters.AddWithValue("@StudentID", studentId);
                        lblPendingComplaints.Text = cmd.ExecuteScalar()?.ToString() ?? "0";
                    }
                }
                catch { lblPendingComplaints.Text = "0"; }
            }
        }
        // ============================================
        // LOAD REPLY NOTIFICATIONS (unread count)
        // ============================================
        private void LoadReplyNotifications()
        {
            int studentId = Convert.ToInt32(Session["UserID"]);

            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand(
                        @"SELECT COUNT(*) FROM ReplyNotifications
                          WHERE UserID = @StudentID AND IsRead = 0", con))
                    {
                        cmd.Parameters.AddWithValue("@StudentID", studentId);
                        con.Open();
                        int count = Convert.ToInt32(cmd.ExecuteScalar());

                        if (count > 0)
                        {
                            lblReplyCount.Text = count.ToString();
                            pnlReplyBadge.Visible = true;
                        }
                        else
                        {
                            pnlReplyBadge.Visible = false;
                        }
                    }
                }
            }
            catch
            {
                pnlReplyBadge.Visible = false;
            }
        }

        // ============================================
        // LOAD MY LISTINGS (Recent 5)
        // ============================================
        private void LoadMyListings()
        {
            int studentId = Convert.ToInt32(Session["UserID"]);

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT TOP 5 
                        l.ListingID, l.Title, l.SellingPrice, l.Status, l.PostedDate,
                        c.CategoryName
                    FROM Listings l
                    INNER JOIN Categories c ON l.CategoryID = c.CategoryID
                    WHERE l.UserID = @StudentID
                    ORDER BY l.PostedDate DESC";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@StudentID", studentId);
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        if (dt.Rows.Count > 0)
                        {
                            rptMyListings.DataSource = dt;
                            rptMyListings.DataBind();
                            pnlNoListings.Visible = false;
                        }
                        else
                        {
                            rptMyListings.Visible = false;
                            pnlNoListings.Visible = true;
                        }
                    }
                }
            }
        }

        // ============================================
        // LOAD RECENT PAYMENTS (Recent 5)
        // ============================================
        private void LoadRecentPayments()
        {
            int studentId = Convert.ToInt32(Session["UserID"]);

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT TOP 5 
                        p.PaymentID, p.Amount, p.PaymentDate, p.PaymentStatus,
                        p.PayerUserID, l.Title
                    FROM Payments p
                    INNER JOIN Listings l ON p.ListingID = l.ListingID
                    WHERE (p.PayerUserID = @StudentID OR l.UserID = @StudentID)
                      AND p.PaymentStatus IN ('Completed','Success')
                    ORDER BY p.PaymentDate DESC";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@StudentID", studentId);
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        if (dt.Rows.Count > 0)
                        {
                            rptRecentPayments.DataSource = dt;
                            rptRecentPayments.DataBind();
                            pnlNoPayments.Visible = false;
                        }
                        else
                        {
                            rptRecentPayments.Visible = false;
                            pnlNoPayments.Visible = true;
                        }
                    }
                }
            }
        }

        // ============================================
        // LOAD RECENT COMPLAINTS (Recent 5)
        // ============================================
        private void LoadRecentComplaints()
        {
            int studentId = Convert.ToInt32(Session["UserID"]);

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT TOP 5 
                        ComplaintID, Subject, Description, Category, 
                        Priority, Status, CreatedDate
                    FROM Complaints
                    WHERE UserID = @StudentID
                    ORDER BY CreatedDate DESC";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@StudentID", studentId);
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        if (dt.Rows.Count > 0)
                        {
                            rptRecentComplaints.DataSource = dt;
                            rptRecentComplaints.DataBind();
                            pnlNoComplaints.Visible = false;
                        }
                        else
                        {
                            rptRecentComplaints.Visible = false;
                            pnlNoComplaints.Visible = true;
                        }
                    }
                }
            }
        }

        // ============================================
        // LOAD RECENT ACTIVITY (Combined feed)
        // ============================================
        private void LoadRecentActivity()
        {
            int studentId = Convert.ToInt32(Session["UserID"]);
            DataTable dt = new DataTable();
            dt.Columns.Add("ActivityType", typeof(string));
            dt.Columns.Add("ActivityIcon", typeof(string));
            dt.Columns.Add("ActivityTitle", typeof(string));
            dt.Columns.Add("ActivityDesc", typeof(string));
            dt.Columns.Add("ActivityDate", typeof(DateTime));

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();

                // 1. Recent Listings posted
                try
                {
                    using (SqlCommand cmd = new SqlCommand(
                        @"SELECT TOP 3 Title, PostedDate, Status
                          FROM Listings
                          WHERE UserID = @StudentID
                          ORDER BY PostedDate DESC", con))
                    {
                        cmd.Parameters.AddWithValue("@StudentID", studentId);
                        using (SqlDataReader rdr = cmd.ExecuteReader())
                        {
                            while (rdr.Read())
                            {
                                DataRow row = dt.NewRow();
                                row["ActivityType"] = "listing";
                                row["ActivityIcon"] = "fas fa-tag";
                                row["ActivityTitle"] = "Listing Posted";
                                row["ActivityDesc"] = $"You posted \"{rdr["Title"]}\" — {rdr["Status"]}";
                                row["ActivityDate"] = Convert.ToDateTime(rdr["PostedDate"]);
                                dt.Rows.Add(row);
                            }
                        }
                    }
                }
                catch { }

                // 2. Recent Payments
                try
                {
                    using (SqlCommand cmd = new SqlCommand(
                        @"SELECT TOP 3 p.Amount, p.PaymentDate, p.PayerUserID, l.Title
                          FROM Payments p
                          INNER JOIN Listings l ON p.ListingID = l.ListingID
                          WHERE (p.PayerUserID = @StudentID OR l.UserID = @StudentID)
                            AND p.PaymentStatus IN ('Completed','Success')
                          ORDER BY p.PaymentDate DESC", con))
                    {
                        cmd.Parameters.AddWithValue("@StudentID", studentId);
                        using (SqlDataReader rdr = cmd.ExecuteReader())
                        {
                            while (rdr.Read())
                            {
                                bool isPayer = Convert.ToInt32(rdr["PayerUserID"]) == studentId;
                                DataRow row = dt.NewRow();
                                row["ActivityType"] = "payment";
                                row["ActivityIcon"] = "fas fa-credit-card";
                                row["ActivityTitle"] = isPayer ? "Payment Made" : "Payment Received";
                                row["ActivityDesc"] = isPayer
                                    ? $"You paid ₹{Convert.ToDecimal(rdr["Amount"]):N0} for \"{rdr["Title"]}\""
                                    : $"You received ₹{Convert.ToDecimal(rdr["Amount"]):N0} for \"{rdr["Title"]}\"";
                                row["ActivityDate"] = Convert.ToDateTime(rdr["PaymentDate"]);
                                dt.Rows.Add(row);
                            }
                        }
                    }
                }
                catch { }

                // 3. Recent Listing Requests (as requester)
                try
                {
                    using (SqlCommand cmd = new SqlCommand(
                        @"SELECT TOP 3 lr.RequestDate, lr.Status, lr.RequestType, l.Title
                          FROM ListingRequests lr
                          INNER JOIN Listings l ON lr.RequestedListingID = l.ListingID
                          WHERE lr.RequesterStudentID = @StudentID
                          ORDER BY lr.RequestDate DESC", con))
                    {
                        cmd.Parameters.AddWithValue("@StudentID", studentId);
                        using (SqlDataReader rdr = cmd.ExecuteReader())
                        {
                            while (rdr.Read())
                            {
                                DataRow row = dt.NewRow();
                                row["ActivityType"] = "trade";
                                row["ActivityIcon"] = "fas fa-exchange-alt";
                                row["ActivityTitle"] = $"Request {rdr["RequestType"]}";
                                row["ActivityDesc"] = $"Your {rdr["RequestType"]} request for \"{rdr["Title"]}\" is {rdr["Status"]}";
                                row["ActivityDate"] = Convert.ToDateTime(rdr["RequestDate"]);
                                dt.Rows.Add(row);
                            }
                        }
                    }
                }
                catch { }

                // 4. Recent Replies to Purchase Requests
                try
                {
                    using (SqlCommand cmd = new SqlCommand(
                        @"SELECT TOP 3 pr.ItemName, l.PostedDate, l.Title, u.FullName
                          FROM ReplyNotifications rn
                          INNER JOIN PurchaseRequests pr ON rn.PurchaseRequestID = pr.PurchaseRequestID
                          INNER JOIN Listings l ON rn.ListingID = l.ListingID
                          INNER JOIN Users u ON l.UserID = u.UserID
                          WHERE rn.UserID = @StudentID
                          ORDER BY l.PostedDate DESC", con))
                    {
                        cmd.Parameters.AddWithValue("@StudentID", studentId);
                        using (SqlDataReader rdr = cmd.ExecuteReader())
                        {
                            while (rdr.Read())
                            {
                                DataRow row = dt.NewRow();
                                row["ActivityType"] = "offer";
                                row["ActivityIcon"] = "fas fa-comment-dots";
                                row["ActivityTitle"] = "Reply to Your Request";
                                row["ActivityDesc"] = $"{rdr["FullName"]} replied to \"{rdr["ItemName"]}\" with \"{rdr["Title"]}\"";
                                row["ActivityDate"] = Convert.ToDateTime(rdr["PostedDate"]);
                                dt.Rows.Add(row);
                            }
                        }
                    }
                }
                catch { }

                // 5. Recent Complaints
                try
                {
                    using (SqlCommand cmd = new SqlCommand(
                        @"SELECT TOP 3 Subject, Status, CreatedDate
                          FROM Complaints
                          WHERE UserID = @StudentID
                          ORDER BY CreatedDate DESC", con))
                    {
                        cmd.Parameters.AddWithValue("@StudentID", studentId);
                        using (SqlDataReader rdr = cmd.ExecuteReader())
                        {
                            while (rdr.Read())
                            {
                                DataRow row = dt.NewRow();
                                row["ActivityType"] = "complaint";
                                row["ActivityIcon"] = "fas fa-flag";
                                row["ActivityTitle"] = "Complaint Filed";
                                row["ActivityDesc"] = $"\"{rdr["Subject"]}\" — {rdr["Status"]}";
                                row["ActivityDate"] = Convert.ToDateTime(rdr["CreatedDate"]);
                                dt.Rows.Add(row);
                            }
                        }
                    }
                }
                catch { }
            }

            // Sort combined activity by date desc and take top 8
            DataView dv = dt.DefaultView;
            dv.Sort = "ActivityDate DESC";

            DataTable sortedDt = dv.ToTable().Clone();
            int count = 0;
            foreach (DataRowView drv in dv)
            {
                if (count >= 8) break;
                sortedDt.ImportRow(drv.Row);
                count++;
            }

            if (sortedDt.Rows.Count > 0)
            {
                rptRecentActivity.DataSource = sortedDt;
                rptRecentActivity.DataBind();
                pnlNoActivity.Visible = false;
            }
            else
            {
                rptRecentActivity.Visible = false;
                pnlNoActivity.Visible = true;
            }
        }

        // ============================================
        // HELPERS
        // ============================================
        protected string GetTimeAgo(DateTime dateTime)
        {
            TimeSpan ts = DateTime.Now - dateTime;

            if (ts.TotalDays >= 30)
                return $"{(int)(ts.TotalDays / 30)} month(s) ago";
            if (ts.TotalDays >= 1)
                return $"{(int)ts.TotalDays} day(s) ago";
            if (ts.TotalHours >= 1)
                return $"{(int)ts.TotalHours} hour(s) ago";
            if (ts.TotalMinutes >= 1)
                return $"{(int)ts.TotalMinutes} minute(s) ago";
            return "Just now";
        }

        protected string Truncate(string text, int maxLen)
        {
            if (string.IsNullOrEmpty(text)) return "";
            return text.Length <= maxLen ? text : text.Substring(0, maxLen) + "...";
        }

        protected string GetListingStatusClass(string status)
        {
            if (string.IsNullOrEmpty(status)) return "pending";
            switch (status.Trim().ToLower())
            {
                case "active": return "active";
                case "sold": return "sold";
                case "swapped": return "swapped";
                case "pending": return "pending";
                case "rejected": return "rejected";
                case "removed":
                case "inactive":
                case "deactive": return "rejected";
                default: return "pending";
            }
        }

        /// <summary>
        /// Maps complaint Status from the database to a CSS class.
        ///   Pending      → pending     (amber #fff3cd)
        ///   In Progress  → inprogress  (blue  #cfe2ff)
        ///   Completed    → completed   (green #d1e7dd)
        ///   Rejected     → rejected    (red   #f8d7da)
        /// </summary>
        protected string GetComplaintStatusClass(string status)
        {
            if (string.IsNullOrEmpty(status)) return "pending";

            switch (status.Trim().ToLower())
            {
                case "pending": return "pending";
                case "in progress": return "inprogress";
                case "completed": return "completed";
                case "rejected": return "rejected";
                default: return "pending";
            }
        }

        protected string GetPaymentDirection(string payerUserId)
        {
            int studentId = Convert.ToInt32(Session["UserID"]);
            return payerUserId == studentId.ToString() ? "up" : "down";
        }

        protected string GetPaymentAmountClass(string payerUserId)
        {
            int studentId = Convert.ToInt32(Session["UserID"]);
            return payerUserId == studentId.ToString() ? "debit" : "credit";
        }

        protected string GetPaymentPrefix(string payerUserId)
        {
            int studentId = Convert.ToInt32(Session["UserID"]);
            return payerUserId == studentId.ToString() ? "-" : "+";
        }
    }
}