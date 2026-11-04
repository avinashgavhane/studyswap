using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace StudySwap.Student
{
    public partial class MyRequests : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["LIS"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserID"] == null)
                {
                    Response.Redirect("~/Login.aspx");
                    return;
                }

                // 🔔 Clear the "+N" reply badge on the dashboard
                MarkReplyNotificationsAsRead();

                LoadMyRequests();
            }
        }

        // ============================================
        // 🔔 MARK ALL UNREAD REPLY NOTIFICATIONS AS READ
        //    Called whenever the user visits this page.
        // ============================================
        private void MarkReplyNotificationsAsRead()
        {
            int studentId = Convert.ToInt32(Session["UserID"]);

            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    using (SqlCommand cmd = new SqlCommand(
                        @"UPDATE ReplyNotifications 
                          SET IsRead = 1 
                          WHERE UserID = @StudentID AND IsRead = 0", con))
                    {
                        cmd.Parameters.AddWithValue("@StudentID", studentId);
                        con.Open();
                        cmd.ExecuteNonQuery();
                    }
                }
            }
            catch
            {
                // Silent — clearing the badge is non-critical
            }
        }

        // ============================================
        // LOAD MY REQUESTS
        // ============================================
        private void LoadMyRequests()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"
            SELECT 
                R.RequestID,
                R.RequestType,
                R.RequestDate,
                R.Status,
                L.Title,
                L.SellingPrice,
                P.Amount,
                EL.Title AS ExchangeTitle
            FROM ListingRequests R
            INNER JOIN Listings L ON R.RequestedListingID = L.ListingID
            LEFT JOIN Listings EL ON R.ExchangeListingID = EL.ListingID
            LEFT JOIN Payments P ON R.RequestID = P.RequestID
            WHERE R.RequesterStudentID = @UserID
            ORDER BY R.RequestDate DESC";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                if (dt.Rows.Count > 0)
                {
                    rptRequests.DataSource = dt;
                    rptRequests.DataBind();
                    lblEmpty.Visible = false;
                }
                else
                {
                    rptRequests.DataSource = null;
                    rptRequests.DataBind();
                    lblEmpty.Visible = true;
                }
            }
        }
    }
}