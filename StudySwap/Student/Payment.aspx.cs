using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace StudySwap.Student
{
    public partial class Payment : Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["LIS"].ConnectionString;

        protected int ListingID
        {
            get
            {
                int id;
                return int.TryParse(Request.QueryString["ListingID"], out id) ? id : 0;
            }
        }

        protected decimal Price
        {
            get
            {
                decimal p;
                return decimal.TryParse(Request.QueryString["Price"], out p) ? p : 0;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserID"] == null || ListingID == 0 || Price == 0)
                    Response.Redirect("BrowseItems.aspx");

                lblAmount.Text = Price.ToString("₹0.00");
            }
        }

        protected void btnPayNow_Click(object sender, EventArgs e)
        {
            SaveBuyRequest();
        }

        private void SaveBuyRequest()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                using (SqlTransaction tran = con.BeginTransaction())
                {
                    try
                    {
                        // Insert into ListingRequests and get new RequestID
                        string insertRequestQuery = @"
                    INSERT INTO ListingRequests
                        (RequestedListingID, RequesterStudentID, RequestType, ExchangeListingID, RequestDate, Status)
                    OUTPUT INSERTED.RequestID
                    VALUES
                        (@ListingID, @UserID, 'Buy', NULL, GETDATE(), 'Paid')";

                        SqlCommand cmdRequest = new SqlCommand(insertRequestQuery, con, tran);
                        cmdRequest.Parameters.AddWithValue("@ListingID", ListingID);
                        cmdRequest.Parameters.AddWithValue("@UserID", Session["UserID"]);
                      

                        int newRequestID = (int)cmdRequest.ExecuteScalar();

                        // Insert into Payments
                        string insertPaymentQuery = @"
                    INSERT INTO Payments
                        (RequestID, ListingID, PayerUserID, Amount, PaymentMethod, TransactionRef, PaymentStatus, PaymentDate)
                    VALUES
                        (@RequestID, @ListingID, @UserID, @Amount, @PaymentMethod, @TransactionRef, @PaymentStatus, GETDATE())";

                        SqlCommand cmdPayment = new SqlCommand(insertPaymentQuery, con, tran);
                        cmdPayment.Parameters.AddWithValue("@RequestID", newRequestID);
                        cmdPayment.Parameters.AddWithValue("@ListingID", ListingID);
                        cmdPayment.Parameters.AddWithValue("@UserID", Session["UserID"]);
                        cmdPayment.Parameters.AddWithValue("@Amount", Price);
                        cmdPayment.Parameters.AddWithValue("@PaymentMethod", "Online"); // or whatever your method is
                        cmdPayment.Parameters.AddWithValue("@TransactionRef", Guid.NewGuid().ToString()); // example transaction ref
                        cmdPayment.Parameters.AddWithValue("@PaymentStatus", "Completed"); // or "Paid"

                        cmdPayment.ExecuteNonQuery();

                     
                        // Update Listing status to 'Deactive'
                        string updateListingStatusQuery = @"
                    UPDATE Listings
                    SET Status = 'Removed'
                    WHERE ListingID = @ListingID";

                        SqlCommand cmdUpdateListing = new SqlCommand(updateListingStatusQuery, con, tran);
                        cmdUpdateListing.Parameters.AddWithValue("@ListingID", ListingID);

                        cmdUpdateListing.ExecuteNonQuery();

                        tran.Commit();

                        Response.Redirect("MyRequests.aspx");
                    }
                    catch (Exception ex)
                    {
                        tran.Rollback();
                        // handle error (log it and show message)
                        lblMsg.Text = "Payment failed: " + ex.Message;
                        lblMsg.Visible = true;
                    }
                }
            }
        }
    }
}