using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace StudySwap.Admin
{
    public partial class ViewUsers : System.Web.UI.Page
    {
        string cs = ConfigurationManager.ConnectionStrings["LIS"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadStats();
                UpdatePurgeCountBadge();
                LoadUsers();
            }
        }

        // ============================================
        // LOAD STATS FOR CARDS
        // ============================================
        private void LoadStats()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();
                    string query = @"
                        SELECT 
                            COUNT(*) AS TotalStudents,
                            ISNULL(SUM(CASE WHEN YearOfStudy = 4 THEN 1 ELSE 0 END), 0) AS PassoutCount,
                            ISNULL(SUM(CASE WHEN YearOfStudy = 3 THEN 1 ELSE 0 END), 0) AS Year3Count,
                            ISNULL(SUM(CASE WHEN YearOfStudy IN (1, 2) THEN 1 ELSE 0 END), 0) AS JuniorCount
                        FROM Users
                        WHERE UserRole = 'Student' OR UserRole IS NULL OR UserRole <> 'Admin'";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        using (SqlDataReader dr = cmd.ExecuteReader())
                        {
                            if (dr.Read())
                            {
                                lblStatTotal.Text = dr["TotalStudents"].ToString();
                                lblStatPassout.Text = dr["PassoutCount"].ToString();
                                lblStatYear3.Text = dr["Year3Count"].ToString();
                                lblStatJunior.Text = dr["JuniorCount"].ToString();
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowAlert("Failed to load summary stats: " + ex.Message, false);
            }
        }

        // ============================================
        // UPDATE PURGE COUNT BADGE FOR SELECTED BATCH
        // ============================================
        private void UpdatePurgeCountBadge()
        {
            try
            {
                int year = Convert.ToInt32(ddlPurgeBatch.SelectedValue);
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();
                    string q = "SELECT COUNT(*) FROM Users WHERE YearOfStudy = @Year AND (UserRole = 'Student' OR UserRole IS NULL OR UserRole <> 'Admin')";
                    using (SqlCommand cmd = new SqlCommand(q, con))
                    {
                        cmd.Parameters.AddWithValue("@Year", year);
                        int count = (int)cmd.ExecuteScalar();
                        lblPurgeCount.Text = $"({count} student{(count == 1 ? "" : "s")} enrolled)";
                    }
                }
            }
            catch
            {
                lblPurgeCount.Text = "";
            }
        }

        protected void ddlPurgeBatch_SelectedIndexChanged(object sender, EventArgs e)
        {
            UpdatePurgeCountBadge();
        }

        // ============================================
        // LOAD USERS WITH BATCH FILTER
        // ============================================
        private void LoadUsers()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();
                    string filter = ddlBatchFilter.SelectedValue;

                    string query = @"
                        SELECT 
                            u.UserID,
                            u.FullName,
                            u.Email,
                            u.Phone,
                            u.YearOfStudy,
                            ISNULL(u.RollNumber, 'N/A') AS RollNumber,
                            COALESCE(d.DepartmentCode, u.Department, 'N/A') AS DeptCode,
                            ISNULL(u.UserRole, 'Student') AS Role,
                            ISNULL(u.AccountStatus, 'Active') AS Status,
                            u.IsVerified
                        FROM Users u
                        LEFT JOIN Departments d ON TRY_CAST(u.Department AS INT) = d.DepartmentID
                        WHERE (u.UserRole = 'Student' OR u.UserRole IS NULL OR u.UserRole <> 'Admin')";

                    if (!string.IsNullOrEmpty(filter))
                    {
                        query += " AND u.YearOfStudy = @YearFilter";
                    }

                    query += " ORDER BY u.UserID DESC";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        if (!string.IsNullOrEmpty(filter))
                        {
                            cmd.Parameters.AddWithValue("@YearFilter", Convert.ToInt32(filter));
                        }

                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        rptUsers.DataSource = dt;
                        rptUsers.DataBind();
                    }
                }
            }
            catch (Exception ex)
            {
                ShowAlert("⚠ Error loading users: " + ex.Message, false);
            }
        }

        // ============================================
        // BATCH FILTER CHANGED
        // ============================================
        protected void ddlBatchFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadUsers();
        }

        // ============================================
        // REFRESH BUTTON
        // ============================================
        protected void btnRefresh_Click(object sender, EventArgs e)
        {
            LoadStats();
            UpdatePurgeCountBadge();
            LoadUsers();
            ShowAlert("✓ Data refreshed successfully.", true);
        }

        // ============================================
        // REPEATER COMMANDS (INDIVIDUAL DELETE)
        // ============================================
        protected void rptUsers_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "DeleteUser")
            {
                int userId = Convert.ToInt32(e.CommandArgument);
                DeleteSingleUser(userId);
                LoadStats();
                UpdatePurgeCountBadge();
                LoadUsers();
            }
        }

        // ============================================
        // PURGE ENTIRE BATCH (BULK DELETION)
        // ============================================
        protected void btnPurgeBatch_Click(object sender, EventArgs e)
        {
            int year = Convert.ToInt32(ddlPurgeBatch.SelectedValue);
            DeleteBatch(year);
            LoadStats();
            UpdatePurgeCountBadge();
            LoadUsers();
        }

        // ============================================
        // DELETE BATCH LOGIC
        // ============================================
        private void DeleteBatch(int yearOfStudy)
        {
            string batchName = GetBatchName(yearOfStudy);

            try
            {
                List<string> filesToDelete = new List<string>();
                int studentCount = 0;
                int listingCount = 0;

                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();

                    // Step 1: Check how many students exist in this batch
                    string countQ = "SELECT COUNT(*) FROM Users WHERE YearOfStudy = @Year AND (UserRole = 'Student' OR UserRole IS NULL OR UserRole <> 'Admin')";
                    using (SqlCommand cmdCount = new SqlCommand(countQ, con))
                    {
                        cmdCount.Parameters.AddWithValue("@Year", yearOfStudy);
                        studentCount = (int)cmdCount.ExecuteScalar();
                    }

                    if (studentCount == 0)
                    {
                        ShowAlert($"No students found in {batchName} to purge.", false);
                        return;
                    }

                    // Step 2: Collect physical file paths for all listings and profiles in this batch
                    string getListingFilesQ = @"
                        SELECT l.Image1Path, l.Image2Path, l.Image3Path
                        FROM Listings l
                        INNER JOIN Users u ON l.UserID = u.UserID
                        WHERE u.YearOfStudy = @Year AND (u.UserRole = 'Student' OR u.UserRole IS NULL OR u.UserRole <> 'Admin')";
                    using (SqlCommand cmdLF = new SqlCommand(getListingFilesQ, con))
                    {
                        cmdLF.Parameters.AddWithValue("@Year", yearOfStudy);
                        using (SqlDataReader r = cmdLF.ExecuteReader())
                        {
                            while (r.Read())
                            {
                                listingCount++;
                                if (r["Image1Path"] != DBNull.Value) filesToDelete.Add(r["Image1Path"].ToString());
                                if (r["Image2Path"] != DBNull.Value) filesToDelete.Add(r["Image2Path"].ToString());
                                if (r["Image3Path"] != DBNull.Value) filesToDelete.Add(r["Image3Path"].ToString());
                            }
                        }
                    }

                    string getUserFilesQ = @"
                        SELECT StudentIDProofPath, ProfilePicture 
                        FROM Users 
                        WHERE YearOfStudy = @Year AND (UserRole = 'Student' OR UserRole IS NULL OR UserRole <> 'Admin')";
                    using (SqlCommand cmdUF = new SqlCommand(getUserFilesQ, con))
                    {
                        cmdUF.Parameters.AddWithValue("@Year", yearOfStudy);
                        using (SqlDataReader r = cmdUF.ExecuteReader())
                        {
                            while (r.Read())
                            {
                                if (r["StudentIDProofPath"] != DBNull.Value) filesToDelete.Add(r["StudentIDProofPath"].ToString());
                                if (r["ProfilePicture"] != DBNull.Value) filesToDelete.Add(r["ProfilePicture"].ToString());
                            }
                        }
                    }

                    // Step 3: Cascading Deletion inside SqlTransaction
                    using (SqlTransaction tran = con.BeginTransaction())
                    {
                        try
                        {
                            // A. Subquery filter for batch users
                            string userSubQuery = "(SELECT UserID FROM Users WHERE YearOfStudy = @Year AND (UserRole = 'Student' OR UserRole IS NULL OR UserRole <> 'Admin'))";
                            string listingSubQuery = $"(SELECT ListingID FROM Listings WHERE UserID IN {userSubQuery})";

                            // 1. ReplyNotifications
                            SqlCommand cmdNotif = new SqlCommand($"DELETE FROM ReplyNotifications WHERE UserID IN {userSubQuery}", con, tran);
                            cmdNotif.Parameters.AddWithValue("@Year", yearOfStudy);
                            cmdNotif.ExecuteNonQuery();

                            // 2. Complaints
                            SqlCommand cmdComp = new SqlCommand(
                                $"DELETE FROM Complaints WHERE UserID IN {userSubQuery} OR RelatedListingID IN {listingSubQuery}", con, tran);
                            cmdComp.Parameters.AddWithValue("@Year", yearOfStudy);
                            cmdComp.ExecuteNonQuery();

                            // 3. Payments
                            SqlCommand cmdPay = new SqlCommand(
                                $"DELETE FROM Payments WHERE PayerUserID IN {userSubQuery} OR ListingID IN {listingSubQuery}", con, tran);
                            cmdPay.Parameters.AddWithValue("@Year", yearOfStudy);
                            cmdPay.ExecuteNonQuery();

                            // 4. ListingRequests
                            SqlCommand cmdReq = new SqlCommand(
                                $"DELETE FROM ListingRequests WHERE RequesterStudentID IN {userSubQuery} OR RequestedListingID IN {listingSubQuery} OR ExchangeListingID IN {listingSubQuery}", con, tran);
                            cmdReq.Parameters.AddWithValue("@Year", yearOfStudy);
                            cmdReq.ExecuteNonQuery();

                            // 5. PurchaseRequests
                            SqlCommand cmdPR = new SqlCommand(
                                $"DELETE FROM PurchaseRequests WHERE RequesterUserID IN {userSubQuery}", con, tran);
                            cmdPR.Parameters.AddWithValue("@Year", yearOfStudy);
                            cmdPR.ExecuteNonQuery();

                            // 6. Listings
                            SqlCommand cmdList = new SqlCommand(
                                $"DELETE FROM Listings WHERE UserID IN {userSubQuery}", con, tran);
                            cmdList.Parameters.AddWithValue("@Year", yearOfStudy);
                            cmdList.ExecuteNonQuery();

                            // 7. Users
                            SqlCommand cmdUsers = new SqlCommand(
                                $"DELETE FROM Users WHERE YearOfStudy = @Year AND (UserRole = 'Student' OR UserRole IS NULL OR UserRole <> 'Admin')", con, tran);
                            cmdUsers.Parameters.AddWithValue("@Year", yearOfStudy);
                            int purgedUsers = cmdUsers.ExecuteNonQuery();

                            tran.Commit();

                            // Step 4: Clean up physical disk files
                            int deletedFilesCount = 0;
                            foreach (string relPath in filesToDelete)
                            {
                                try
                                {
                                    if (!string.IsNullOrEmpty(relPath) && relPath.StartsWith("~"))
                                    {
                                        string fullPath = Server.MapPath(relPath);
                                        if (File.Exists(fullPath))
                                        {
                                            File.Delete(fullPath);
                                            deletedFilesCount++;
                                        }
                                    }
                                }
                                catch { /* ignore individual locked files */ }
                            }

                            ShowAlert($"✓ Successfully purged {purgedUsers} student(s) from {batchName}. Cleared {listingCount} listings and deleted {deletedFilesCount} physical image files.", true);
                        }
                        catch (Exception ex)
                        {
                            tran.Rollback();
                            ShowAlert("Failed to purge batch: " + ex.Message, false);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowAlert("Database connection error: " + ex.Message, false);
            }
        }

        // ============================================
        // DELETE SINGLE USER
        // ============================================
        private void DeleteSingleUser(int userId)
        {
            try
            {
                List<string> filesToDelete = new List<string>();

                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();
                    using (SqlTransaction tran = con.BeginTransaction())
                    {
                        try
                        {
                            // A. Collect listing images
                            string getImgQ = "SELECT Image1Path, Image2Path, Image3Path FROM Listings WHERE UserID = @UID";
                            using (SqlCommand cmdGetImg = new SqlCommand(getImgQ, con, tran))
                            {
                                cmdGetImg.Parameters.AddWithValue("@UID", userId);
                                using (SqlDataReader r = cmdGetImg.ExecuteReader())
                                {
                                    while (r.Read())
                                    {
                                        if (r["Image1Path"] != DBNull.Value) filesToDelete.Add(r["Image1Path"].ToString());
                                        if (r["Image2Path"] != DBNull.Value) filesToDelete.Add(r["Image2Path"].ToString());
                                        if (r["Image3Path"] != DBNull.Value) filesToDelete.Add(r["Image3Path"].ToString());
                                    }
                                }
                            }

                            // B. Collect ID proof & profile picture
                            string getFilesQ = "SELECT StudentIDProofPath, ProfilePicture FROM Users WHERE UserID = @UID";
                            using (SqlCommand cmdGetFiles = new SqlCommand(getFilesQ, con, tran))
                            {
                                cmdGetFiles.Parameters.AddWithValue("@UID", userId);
                                using (SqlDataReader r = cmdGetFiles.ExecuteReader())
                                {
                                    if (r.Read())
                                    {
                                        if (r["StudentIDProofPath"] != DBNull.Value) filesToDelete.Add(r["StudentIDProofPath"].ToString());
                                        if (r["ProfilePicture"] != DBNull.Value) filesToDelete.Add(r["ProfilePicture"].ToString());
                                    }
                                }
                            }

                            // 1. Reply notifications
                            SqlCommand cmdNotif = new SqlCommand("DELETE FROM ReplyNotifications WHERE UserID = @UID", con, tran);
                            cmdNotif.Parameters.AddWithValue("@UID", userId);
                            cmdNotif.ExecuteNonQuery();

                            // 2. Complaints
                            SqlCommand cmdComp = new SqlCommand(
                                "DELETE FROM Complaints WHERE UserID = @UID OR RelatedListingID IN (SELECT ListingID FROM Listings WHERE UserID = @UID)", con, tran);
                            cmdComp.Parameters.AddWithValue("@UID", userId);
                            cmdComp.ExecuteNonQuery();

                            // 3. Payments
                            SqlCommand cmdPay = new SqlCommand(
                                "DELETE FROM Payments WHERE PayerUserID = @UID OR ListingID IN (SELECT ListingID FROM Listings WHERE UserID = @UID)", con, tran);
                            cmdPay.Parameters.AddWithValue("@UID", userId);
                            cmdPay.ExecuteNonQuery();

                            // 4. ListingRequests
                            SqlCommand cmdReq = new SqlCommand(
                                @"DELETE FROM ListingRequests 
                                  WHERE RequesterStudentID = @UID 
                                     OR RequestedListingID IN (SELECT ListingID FROM Listings WHERE UserID = @UID)
                                     OR ExchangeListingID IN (SELECT ListingID FROM Listings WHERE UserID = @UID)", con, tran);
                            cmdReq.Parameters.AddWithValue("@UID", userId);
                            cmdReq.ExecuteNonQuery();

                            // 5. PurchaseRequests
                            SqlCommand cmdPR = new SqlCommand("DELETE FROM PurchaseRequests WHERE RequesterUserID = @UID", con, tran);
                            cmdPR.Parameters.AddWithValue("@UID", userId);
                            cmdPR.ExecuteNonQuery();

                            // 6. Listings
                            SqlCommand cmdList = new SqlCommand("DELETE FROM Listings WHERE UserID = @UID", con, tran);
                            cmdList.Parameters.AddWithValue("@UID", userId);
                            cmdList.ExecuteNonQuery();

                            // 7. Users
                            SqlCommand cmdUser = new SqlCommand("DELETE FROM Users WHERE UserID = @UID", con, tran);
                            cmdUser.Parameters.AddWithValue("@UID", userId);
                            int rows = cmdUser.ExecuteNonQuery();

                            tran.Commit();

                            // Clean up physical files
                            foreach (string relPath in filesToDelete)
                            {
                                try
                                {
                                    if (!string.IsNullOrEmpty(relPath) && relPath.StartsWith("~"))
                                    {
                                        string fullPath = Server.MapPath(relPath);
                                        if (File.Exists(fullPath))
                                        {
                                            File.Delete(fullPath);
                                        }
                                    }
                                }
                                catch { }
                            }

                            if (rows > 0)
                            {
                                ShowAlert("✓ Student (ID #" + userId + ") and all associated images were permanently deleted.", true);
                            }
                            else
                            {
                                ShowAlert("Student ID #" + userId + " was not found.", false);
                            }
                        }
                        catch (Exception ex)
                        {
                            tran.Rollback();
                            ShowAlert("Failed to delete student: " + ex.Message, false);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowAlert("Database connection error: " + ex.Message, false);
            }
        }

        // ============================================
        // ALERT HELPER
        // ============================================
        private void ShowAlert(string message, bool isSuccess)
        {
            lblAlert.Text = message;
            divAlert.Attributes["class"] = isSuccess ? "alert-msg alert-success" : "alert-msg alert-error";
            pnlAlert.Visible = true;
        }

        // ============================================
        // BATCH NAME HELPER
        // ============================================
        private string GetBatchName(int year)
        {
            switch (year)
            {
                case 4: return "4th Year (Passout Cohort • Semesters 7 & 8)";
                case 3: return "3rd Year (Semesters 5 & 6)";
                case 2: return "2nd Year (Semesters 3 & 4)";
                case 1: return "1st Year (Semesters 1 & 2)";
                default: return $"Year {year} Cohort";
            }
        }

        // ============================================
        // BADGE HELPERS (PUBLIC FOR ASPX EVAL)
        // ============================================
        public string GetBatchBadge(object yearObj)
        {
            if (yearObj == null || yearObj == DBNull.Value)
                return "<span class='batch-badge batch-unknown'><i class='fa-solid fa-question'></i> Unassigned</span>";

            int yr;
            if (!int.TryParse(yearObj.ToString(), out yr))
                return "<span class='batch-badge batch-unknown'>Unassigned</span>";

            switch (yr)
            {
                case 4:
                    return "<span class='batch-badge batch-passout' title='Semesters 7 & 8 — Graduating / Passout Batch'><i class='fa-solid fa-graduation-cap'></i> 4th Yr (Passout)</span>";
                case 3:
                    return "<span class='batch-badge batch-yr3' title='Semesters 5 & 6'><i class='fa-solid fa-book-bookmark'></i> 3rd Yr (Sem 5-6)</span>";
                case 2:
                    return "<span class='batch-badge batch-yr2' title='Semesters 3 & 4'><i class='fa-solid fa-book-open'></i> 2nd Yr (Sem 3-4)</span>";
                case 1:
                    return "<span class='batch-badge batch-yr1' title='Semesters 1 & 2'><i class='fa-solid fa-seedling'></i> 1st Yr (Sem 1-2)</span>";
                default:
                    return $"<span class='batch-badge batch-unknown'>Year {yr}</span>";
            }
        }

        public string GetStatusBadge(object status)
        {
            string s = (status == null || status == DBNull.Value) ? "Inactive" : status.ToString();

            if (s.Equals("Active", StringComparison.OrdinalIgnoreCase))
                return "<span class='badge-status badge-active'>Active</span>";
            else if (s.Equals("Suspended", StringComparison.OrdinalIgnoreCase))
                return "<span class='badge-status badge-suspended'>Suspended</span>";
            else
                return "<span class='badge-status badge-inactive'>Inactive</span>";
        }

        public string GetRoleBadge(object role)
        {
            string r = (role == null || role == DBNull.Value) ? "Student" : role.ToString();

            if (r.Equals("Tutor", StringComparison.OrdinalIgnoreCase))
                return "<span class='role-badge role-tutor'>Tutor</span>";
            else if (r.Equals("Admin", StringComparison.OrdinalIgnoreCase))
                return "<span class='role-badge role-admin'>Admin</span>";
            else
                return "<span class='role-badge role-student'>Student</span>";
        }
    }
}
