using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace StudySwap.Student
{
    public partial class ViewAllPurchaseRequest : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["LIS"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadAllPurchaseRequests();
            }
        }

        protected void rptAllRequests_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Reply")
            {
                int purchaseRequestId = Convert.ToInt32(e.CommandArgument);
                Response.Redirect("Listing.aspx?ReplyID=" + purchaseRequestId);
            }
        }

        private void LoadAllPurchaseRequests()
        {
            int currentUserID = Convert.ToInt32(Session["UserID"]);

            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT 
                        pr.PurchaseRequestID, 
                        pr.ItemName, 
                        pr.Description, 
                        pr.Status, 
                        u.FullName AS RequesterName
                    FROM PurchaseRequests pr
                    INNER JOIN Users u ON pr.RequesterUserID = u.UserID
                    WHERE pr.RequesterUserID <> @CurrentUserID
                      AND pr.Status = 'Active'
                      -- ❌ Exclude requests already fulfilled by a paid listing
                      AND NOT EXISTS (
                          SELECT 1
                          FROM Listings l
                          INNER JOIN Payments p ON p.ListingID = l.ListingID
                          WHERE l.ReplyID = pr.PurchaseRequestID
                            AND p.PaymentStatus IN ('Completed','Success')
                      )
                    ORDER BY pr.CreatedDate DESC";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@CurrentUserID", currentUserID);

                    con.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.HasRows)
                        {
                            rptAllRequests.DataSource = reader;
                            rptAllRequests.DataBind();
                            rptAllRequests.Visible = true;
                            lblNoRequests.Visible = false;
                        }
                        else
                        {
                            rptAllRequests.Visible = false;
                            lblNoRequests.Visible = true;
                        }
                    }
                }
            }
        }
    }
}