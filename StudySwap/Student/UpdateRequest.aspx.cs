using System;
using System.Configuration;
using System.Data.SqlClient;

namespace StudySwap.Student
{
    public partial class UpdateRequest : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["LIS"].ConnectionString;

        protected int RequestID
        {
            get
            {
                return Session["RequestID"] != null
                    ? Convert.ToInt32(Session["RequestID"])
                    : 0;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserID"] == null || RequestID == 0)
                {
                    Response.Redirect("Dashboard.aspx");
                    return;
                }

                LoadRequestDetails();
            }
        }

        private void LoadRequestDetails()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string q = @"
          SELECT 
                R.RequestType, R.Status, R.ExchangeListingID,
                S.FullName, S.Email, S.Phone,

                L.Title AS ReqTitle, 
                L.SellingPrice AS ReqPrice,
                L.Image1Path, L.Image2Path, L.Image3Path,

                EL.Title AS ExTitle, 
                EL.SellingPrice AS ExPrice,
                EL.Image1Path AS ExImg1,
                EL.Image2Path AS ExImg2,
                EL.Image3Path AS ExImg3

            FROM ListingRequests R
            INNER JOIN Users S 
                ON R.RequesterStudentID = S.UserID
            INNER JOIN Listings L 
                ON R.RequestedListingID = L.ListingID
            LEFT JOIN Listings EL 
                ON R.ExchangeListingID = EL.ListingID
            WHERE R.RequestID = @RequestID
        ";

                SqlCommand cmd = new SqlCommand(q, con);
                cmd.Parameters.AddWithValue("@RequestID", RequestID);

                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    // Requested Product Info (always shown)
                    lblStudentName.Text = dr["FullName"].ToString();
                    lblStudentEmail.Text = dr["Email"].ToString();
                    lblmobile.Text = dr["Phone"].ToString();

                    lblReqTitle.Text = dr["ReqTitle"].ToString();
                    lblReqPrice.Text = "₹" + dr["ReqPrice"].ToString();

                   //// lblType.Text = dr["RequestType"].ToString();
                   // lblStatus.Text = dr["Status"].ToString();

                   // if (dr["Image1Path"] != DBNull.Value)
                   //     img1.ImageUrl = dr["Image1Path"].ToString();

                   // if (dr["Image2Path"] != DBNull.Value)
                   //     img2.ImageUrl = dr["Image2Path"].ToString();

                   // if (dr["Image3Path"] != DBNull.Value)
                   //     img3.ImageUrl = dr["Image3Path"].ToString();

                    // Exchange Product Info (only if exists)
                    if (dr["ExchangeListingID"] != DBNull.Value)
                    {
                        pnlExchange.Visible = true;

                        lblExTitle.Text = dr["ExTitle"].ToString();
                        lblExPrice.Text = "₹" + dr["ExPrice"].ToString();

                        if (dr["ExImg1"] != DBNull.Value)
                            exImg1.ImageUrl = dr["ExImg1"].ToString();

                        if (dr["ExImg2"] != DBNull.Value)
                            exImg2.ImageUrl = dr["ExImg2"].ToString();

                        if (dr["ExImg3"] != DBNull.Value)
                            exImg3.ImageUrl = dr["ExImg3"].ToString();
                    }
                    else
                    {
                        pnlExchange.Visible = false;
                    }
                }
            }
        }

        protected void btnApprove_Click(object sender, EventArgs e)
        {
            UpdateStatus("Approved");
        }

        protected void btnReject_Click(object sender, EventArgs e)
        {
            UpdateStatus("Rejected");
        }

        private void UpdateStatus(string finalStatus)
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                using (SqlTransaction tran = con.BeginTransaction())
                {
                    try
                    {
                        // Update ListingRequests status
                        string updateRequestStatusQuery = @"
                    UPDATE ListingRequests
                    SET Status = @Status,
                        FinalStatus = @Status
                    WHERE RequestID = @RequestID";

                        SqlCommand cmd1 = new SqlCommand(updateRequestStatusQuery, con, tran);
                        cmd1.Parameters.AddWithValue("@Status", finalStatus);
                        cmd1.Parameters.AddWithValue("@RequestID", RequestID);
                        cmd1.ExecuteNonQuery();

                        if (finalStatus == "Approved")
                        {
                            // Get RequestedListingID from ListingRequests
                            string getListingIdQuery = @"
                        SELECT RequestedListingID 
                        FROM ListingRequests
                        WHERE RequestID = @RequestID";

                            SqlCommand cmdGetListingId = new SqlCommand(getListingIdQuery, con, tran);
                            cmdGetListingId.Parameters.AddWithValue("@RequestID", RequestID);
                            object listingIdObj = cmdGetListingId.ExecuteScalar();

                            if (listingIdObj != null && listingIdObj != DBNull.Value)
                            {
                                int listingId = Convert.ToInt32(listingIdObj);

                                // Update Listing status to 'Removed'
                                string updateListingStatusQuery = @"
                            UPDATE Listings
                            SET Status = 'Removed'
                            WHERE ListingID = @ListingID";

                                SqlCommand cmd2 = new SqlCommand(updateListingStatusQuery, con, tran);
                                cmd2.Parameters.AddWithValue("@ListingID", listingId);
                                cmd2.ExecuteNonQuery();
                            }
                        }

                        tran.Commit();

                        lblMsg.Text = "Request " + finalStatus + " successfully.";
                        lblMsg.CssClass = finalStatus == "Approved"
                            ? "text-success fw-bold"
                            : "text-danger fw-bold";

                        lblMsg.Visible = true;
                        btnApprove.Enabled = false;
                        btnReject.Enabled = false;

                        Session.Remove("RequestID");
                    }
                    catch (Exception ex)
                    {
                        tran.Rollback();
                        lblMsg.Text = "Error updating status: " + ex.Message;
                        lblMsg.CssClass = "text-danger fw-bold";
                        lblMsg.Visible = true;
                    }
                }
            }
        }
    }
}