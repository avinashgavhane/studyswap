using System;
using System.Configuration;
using System.Data.SqlClient;

namespace StudySwap.Student
{
    public partial class PurchaseReplyProductdetails : System.Web.UI.Page
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
                if (!int.TryParse(Request.QueryString["ListingID"], out int listingId))
                {
                    pnlNotFound.Visible = true;
                    return;
                }

                LoadProductDetails(listingId);
            }
        }

        private void LoadProductDetails(int listingId)
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT
                        Title,
                        Description,
                        SellingPrice,
                        [Condition],
                        PostedDate,
                        Image1Path,
                        Image2Path,
                        Image3Path,
                        ReplyID
                    FROM Listings
                    WHERE ListingID = @ListingID
                      AND ReplyID IS NOT NULL";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@ListingID", listingId);

                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                if (!dr.Read())
                {
                    pnlNotFound.Visible = true;
                    return;
                }

                // 🔑 Hidden fields
                hfListingID.Value = listingId.ToString();
                hfRequestID.Value = dr["ReplyID"].ToString();

                var status = GetRequestStatus(Convert.ToInt32(hfRequestID.Value));

                // 🔒 Purchased → FULL LOCK
                if (status.Reaction == "Purchased" || status.PaymentExists)
                {
                    btnBuyNow.Enabled = false;
                    btnNotInterested.Enabled = false;
                    lblMessage.Text = "ℹ️ This product has already been purchased.";
                }
                // 🟡 Not Interested → Buy still allowed
                else if (status.Reaction == "Not Interested")
                {
                    btnNotInterested.Enabled = false;
                    lblMessage.Text = "ℹ️ You marked this as Not Interested earlier. You can still buy it if available.";
                }

                // 🧾 Bind UI
                lblTitle.Text = dr["Title"].ToString();
                lblDescription.Text = dr["Description"].ToString();
                lblPrice.Text = dr["SellingPrice"].ToString();
                lblCondition.Text = dr["Condition"].ToString();
                lblPostedDate.Text = Convert.ToDateTime(dr["PostedDate"]).ToString("dd MMM yyyy");

                string img1 = dr["Image1Path"] as string;
                string img2 = dr["Image2Path"] as string;
                string img3 = dr["Image3Path"] as string;

                imgMain.ImageUrl = !string.IsNullOrEmpty(img1)
                    ? ResolveUrl(img1)
                    : "https://via.placeholder.com/600x400?text=No+Image";

                imgThumb1.ImageUrl = imgMain.ImageUrl;
                imgThumb1.CommandArgument = imgThumb1.ImageUrl;

                imgThumb2.Visible = !string.IsNullOrEmpty(img2);
                imgThumb2.ImageUrl = ResolveUrl(img2);
                imgThumb2.CommandArgument = imgThumb2.ImageUrl;

                imgThumb3.Visible = !string.IsNullOrEmpty(img3);
                imgThumb3.ImageUrl = ResolveUrl(img3);
                imgThumb3.CommandArgument = imgThumb3.ImageUrl;

                pnlProduct.Visible = true;
            }
        }

        // ❌ NOT INTERESTED (non-final)
        protected void btnNotInterested_Click(object sender, EventArgs e)
        {
            int requestId = Convert.ToInt32(hfRequestID.Value);

            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"
                    UPDATE PurchaseRequests
                    SET Reaction = 'Not Interested'
                    WHERE PurchaseRequestID = @RequestID";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@RequestID", requestId);

                con.Open();
                cmd.ExecuteNonQuery();

                btnNotInterested.Enabled = false; // ❗ Buy stays enabled
                lblMessage.Text = "ℹ️ Marked as Not Interested. You can still buy later.";
            }
        }

        // 💳 BUY NOW (final)
        protected void btnBuyNow_Click(object sender, EventArgs e)
        {
            int payerUserId = Convert.ToInt32(Session["UserID"]);
            int listingId = Convert.ToInt32(hfListingID.Value);
            int requestId = Convert.ToInt32(hfRequestID.Value);
            decimal amount = Convert.ToDecimal(lblPrice.Text);

            var status = GetRequestStatus(requestId);

            // 🚫 Block only if already purchased
            if (status.Reaction == "Purchased" || status.PaymentExists)
            {
                lblMessage.Text = "⚠️ Payment already completed.";
                btnBuyNow.Enabled = false;
                btnNotInterested.Enabled = false;
                return;
            }

            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                SqlTransaction tran = con.BeginTransaction();

                try
                {
                    // 1️⃣ INSERT PAYMENT
                    SqlCommand payCmd = new SqlCommand(@"
                INSERT INTO Payments
                (RequestID, ListingID, PayerUserID, Amount,
                 PaymentMethod, TransactionRef, PaymentStatus, PaymentDate)
                VALUES
                (@RequestID, @ListingID, @PayerUserID, @Amount,
                 'DemoPayment', @TxnRef, 'Success', GETDATE())",
                        con, tran);

                    payCmd.Parameters.AddWithValue("@RequestID", requestId);
                    payCmd.Parameters.AddWithValue("@ListingID", listingId);
                    payCmd.Parameters.AddWithValue("@PayerUserID", payerUserId);
                    payCmd.Parameters.AddWithValue("@Amount", amount);
                    payCmd.Parameters.AddWithValue("@TxnRef", Guid.NewGuid().ToString());

                    payCmd.ExecuteNonQuery();

                    // 2️⃣ UPDATE PURCHASE REQUEST → Purchased
                    SqlCommand reqCmd = new SqlCommand(@"
                UPDATE PurchaseRequests
                SET Reaction = 'Purchased'
                WHERE PurchaseRequestID = @RequestID",
                        con, tran);

                    reqCmd.Parameters.AddWithValue("@RequestID", requestId);
                    reqCmd.ExecuteNonQuery();

                    // 3️⃣ UPDATE LISTING STATUS (must match CHECK constraint!)
                    SqlCommand listCmd = new SqlCommand(@"
    UPDATE Listings
    SET Status = 'Deactive',
        LastModified = GETDATE()
    WHERE ListingID = @ListingID",
     con, tran);

                    listCmd.Parameters.AddWithValue("@ListingID", listingId);
                    listCmd.ExecuteNonQuery();

                    tran.Commit();

                    btnBuyNow.Enabled = false;
                    btnNotInterested.Enabled = false;
                    lblMessage.Text = "✅ Payment successful! Listing closed.";
                }
                catch (Exception ex)
                {
                    tran.Rollback();
                    lblMessage.Text = "❌ Payment failed: " + ex.Message;
                }
            }
        }

        private RequestStatus GetRequestStatus(int requestId)
        {
            var status = new RequestStatus();

            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT
                        Reaction,
                        CASE WHEN EXISTS (
                            SELECT 1 FROM Payments WHERE RequestID = @ID
                        ) THEN 1 ELSE 0 END AS PaymentExists
                    FROM PurchaseRequests
                    WHERE PurchaseRequestID = @ID";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@ID", requestId);

                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    status.Reaction = dr["Reaction"]?.ToString();
                    status.PaymentExists = Convert.ToBoolean(dr["PaymentExists"]);
                }
            }
            return status;
        }

        public class RequestStatus
        {
            public string Reaction { get; set; }
            public bool PaymentExists { get; set; }
        }

        protected void Thumbnail_Click(object sender, EventArgs e)
        {
            var img = (System.Web.UI.WebControls.ImageButton)sender;
            imgMain.ImageUrl = img.CommandArgument;
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("BrowseItems.aspx");
        }
    }
}
