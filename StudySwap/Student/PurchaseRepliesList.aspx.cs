using System;
using System.Configuration;
using System.Data.SqlClient;

namespace StudySwap.Student
{
    public partial class PurchaseRepliesList : System.Web.UI.Page
    {
        private string connStr = ConfigurationManager.ConnectionStrings["LIS"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                if (!int.TryParse(Request.QueryString["RequestID"], out int requestId))
                {
                    pnlNoReplies.Visible = true;
                    return;
                }

                LoadReplies(requestId);
            }
        }

        private void LoadReplies(int requestId)
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"
                  SELECT 
    L.ListingID, 
    L.Title, 
    L.SellingPrice, 
    L.[Condition],
    U.FullName,
    U.Email,
    U.Phone
   
  
  

FROM Listings L
INNER JOIN Users U ON L.UserID = U.UserID
WHERE L.ReplyID = @RequestID
AND L.Status = 'Active'
ORDER BY L.PostedDate DESC";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@RequestID", requestId);

                con.Open();
                var reader = cmd.ExecuteReader();

                if (!reader.HasRows)
                {
                    pnlNoReplies.Visible = true;
                    rptReplies.Visible = false;
                    return;
                }

                rptReplies.DataSource = reader;
                rptReplies.DataBind();
            }
        }

        protected void rptReplies_ItemCommand(object source, System.Web.UI.WebControls.RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "ViewDetails")
            {
                int listingId = Convert.ToInt32(e.CommandArgument);
                Response.Redirect($"PurchaseReplyProductdetails.aspx?ListingID={listingId}");
            }
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("ViewPurchaseRequestReaction.aspx");
        }
    }
}
