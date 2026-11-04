using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Web.UI.WebControls;
using System.Web.UI;

namespace StudySwap.Student
{
    public partial class BrowseItems : System.Web.UI.Page
    {
        private string connStr = ConfigurationManager.ConnectionStrings["LIS"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadListings();
               UpdateStats();
            }
        }

        private void LoadListings()
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            int loggedInStudentId = Convert.ToInt32(Session["UserID"]);

            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"
            SELECT ListingID, Title, SellingPrice, Condition, PostedDate, Image1Path
            FROM Listings
            WHERE Status = 'Active'
              AND UserID <> @UserID
AND ReplyID IS NULL     -- <-- exclude listings that are replies
            ORDER BY PostedDate DESC";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@UserID", loggedInStudentId);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                if (dt.Rows.Count > 0)
                {
                    rptListings.DataSource = dt;
                    rptListings.DataBind();
                    lblResultCount.Text = dt.Rows.Count.ToString();
                    pnlEmpty.Visible = false;
                }
                else
                {
                    rptListings.DataSource = null;
                    rptListings.DataBind();
                    lblResultCount.Text = "0";
                    pnlEmpty.Visible = true;
                }
            }
        }
        private void UpdateStats()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = "SELECT COUNT(*) FROM Listings WHERE Status = 'Active'";
                SqlCommand cmd = new SqlCommand(query, con);
                con.Open();
                int totalItems = Convert.ToInt32(cmd.ExecuteScalar());
                //lblTotalItems.Text = totalItems.ToString();
            }
        }
        protected void rptListings_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            

            if (e.CommandName == "ViewDetails")
            {
                Response.Redirect("ListingDetails.aspx?ListingID=" + e.CommandArgument);
            }
        }

      

        // Helper Methods for Display
        protected string GetImagePath(object imagePath)
        {
            if (imagePath == null || string.IsNullOrEmpty(imagePath.ToString()))
            {
                return "https://via.placeholder.com/400x300/667eea/ffffff?text=No+Image";
            }
            return ResolveUrl(imagePath.ToString());
        }

        protected string GetConditionClass(string condition)
        {
            if (string.IsNullOrEmpty(condition))
                return "";

            switch (condition.ToLower().Replace(" ", "-"))
            {
                case "new":
                    return "new";
                case "like-new":
                    return "like-new";
                case "good":
                    return "good";
                case "fair":
                    return "fair";
                default:
                    return "";
            }
        }

        protected string GetFormattedDate(object date)
        {
            if (date == null || date == DBNull.Value)
                return "Unknown";

            DateTime postedDate = Convert.ToDateTime(date);
            return postedDate.ToString("MMM dd, yyyy");
        }
        
        protected string GetRelativeDate(object date)
        {
            if (date == null || date == DBNull.Value)
                return "Unknown";

            DateTime postedDate = Convert.ToDateTime(date);
            TimeSpan diff = DateTime.Now - postedDate;

            if (diff.TotalMinutes < 1)
                return "Just now";
            if (diff.TotalMinutes < 60)
                return $"{(int)diff.TotalMinutes}m ago";
            if (diff.TotalHours < 24)
                return $"{(int)diff.TotalHours}h ago";
            if (diff.TotalDays < 7)
                return $"{(int)diff.TotalDays}d ago";
            if (diff.TotalDays < 30)
                return $"{(int)(diff.TotalDays / 7)}w ago";

            return postedDate.ToString("MMM dd, yyyy");
        }
    }
}