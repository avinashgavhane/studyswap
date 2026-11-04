using System.IO;
using System.Collections.Generic;
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace StudySwap.Student
{
    public partial class MyListing : System.Web.UI.Page
    {
         string connectionString = ConfigurationManager.ConnectionStrings["LIS"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CheckIncomingRequest(); // 🔔 NEW
                BindListings();
            }
        }
        private void ShowMessage(string message, string type)
        {
            requestAlert.Visible = true;
            lblMessage.Text = message;

            


        }
        protected void btnViewRequest_Click(object sender, EventArgs e)
        {
            if (Session["RequestID"] == null)
            {
                ShowMessage("❌ Request not found.", "error");
                return;
            }

            Response.Redirect("UpdateRequest.aspx");
        }
        private void CheckIncomingRequest()
        {
            if (Session["UserID"] == null)
                return;

            int userId = Convert.ToInt32(Session["UserID"]);

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string q = @"
        SELECT TOP 1 
            R.RequestID,
            L.Title,
            R.RequestType,
            R.Status
        FROM ListingRequests R
        INNER JOIN Listings L ON R.RequestedListingID = L.ListingID
        WHERE L.UserID = @UserID
          AND R.Status = 'Pending'
        ORDER BY R.RequestDate DESC";

                SqlCommand cmd = new SqlCommand(q, con);
                cmd.Parameters.AddWithValue("@UserID", userId);

                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.Read())
                {
                    requestAlert.Visible = true;

                    lblRequestInfo.Text =
                        $"Your product <b>{dr["Title"]}</b> has a <b>{dr["RequestType"]}</b> request.";

                    // store request id in session (IMPORTANT)
                    Session["RequestID"] = Convert.ToInt32(dr["RequestID"]);
                }
            }
        }

        private void BindListings()
        {
            // Get student ID from session
            int studentId = Convert.ToInt32(Session["UserID"]);

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
            SELECT 
                l.ListingID,
                l.Title,
                ISNULL(c.CategoryName, 'Unknown') AS CategoryName,
                ISNULL(co.CourseName, 'Unknown') AS CourseName,
                l.Condition,
                l.ListingType,
                l.SellingPrice,
                l.IsPriceNegotiable,
                l.Status
            FROM Listings l
            LEFT JOIN Categories c ON l.CategoryID = c.CategoryID
            LEFT JOIN Courses co ON l.CourseID = co.CourseID
            WHERE l.UserID = @UserID
            ORDER BY l.PostedDate DESC";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@UserID", studentId);

                    using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        sda.Fill(dt);

                        if (dt.Rows.Count > 0)
                        {
                            rptListings.DataSource = dt;
                            rptListings.DataBind();
                            pnlEmpty.Visible = false;
                        }
                        else
                        {
                            rptListings.DataSource = null;
                            rptListings.DataBind();
                            pnlEmpty.Visible = true;
                        }
                    }
                }
            }
        }

        protected void rptListings_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Edit")
            {
                int listingId = Convert.ToInt32(e.CommandArgument);
                LoadListingForEdit(listingId);
            }
        }

        private void LoadListingForEdit(int listingId)
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT 
                        ListingID,
                        Title,
                        Condition,
                        ListingType,
                        SellingPrice,
                        IsPriceNegotiable
                    FROM Listings
                    WHERE ListingID = @ListingID";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@ListingID", listingId);
                    con.Open();

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            hfEditListingID.Value = listingId.ToString();
                            txtEditTitle.Text = dr["Title"].ToString();
                            ddlEditCondition.SelectedValue = dr["Condition"].ToString();
                            ddlEditListingType.SelectedValue = dr["ListingType"].ToString();
                            txtEditPrice.Text = dr["SellingPrice"].ToString();
                            chkEditNegotiable.Checked = Convert.ToBoolean(dr["IsPriceNegotiable"]);
                        }
                    }
                }
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(hfEditListingID.Value))
            {
                int listingId = Convert.ToInt32(hfEditListingID.Value);

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = @"
                        UPDATE Listings
                        SET 
                            Title = @Title,
                            Condition = @Condition,
                            ListingType = @ListingType,
                            SellingPrice = @SellingPrice,
                            IsPriceNegotiable = @IsPriceNegotiable
                           
                        WHERE ListingID = @ListingID";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@ListingID", listingId);
                        cmd.Parameters.AddWithValue("@Title", txtEditTitle.Text.Trim());
                        cmd.Parameters.AddWithValue("@Condition", ddlEditCondition.SelectedValue);
                        cmd.Parameters.AddWithValue("@ListingType", ddlEditListingType.SelectedValue);
                        cmd.Parameters.AddWithValue("@SellingPrice", Convert.ToDecimal(txtEditPrice.Text));
                        cmd.Parameters.AddWithValue("@IsPriceNegotiable", chkEditNegotiable.Checked);

                        con.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                // Clear the hidden field and reload
                hfEditListingID.Value = string.Empty;
                lblMessage.Text = "Listing updated successfully!";
                lblMessage.ForeColor = System.Drawing.Color.Green;
                BindListings();
            }
        }

                protected void btnDelete_Click(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(hfEditListingID.Value))
            {
                int listingId = Convert.ToInt32(hfEditListingID.Value);
                List<string> imagesToDelete = new List<string>();

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();

                    // 1. Fetch image paths before deleting record
                    string getImgQuery = "SELECT Image1Path, Image2Path, Image3Path FROM Listings WHERE ListingID = @ListingID";
                    using (SqlCommand imgCmd = new SqlCommand(getImgQuery, con))
                    {
                        imgCmd.Parameters.AddWithValue("@ListingID", listingId);
                        using (SqlDataReader r = imgCmd.ExecuteReader())
                        {
                            if (r.Read())
                            {
                                if (r["Image1Path"] != DBNull.Value) imagesToDelete.Add(r["Image1Path"].ToString());
                                if (r["Image2Path"] != DBNull.Value) imagesToDelete.Add(r["Image2Path"].ToString());
                                if (r["Image3Path"] != DBNull.Value) imagesToDelete.Add(r["Image3Path"].ToString());
                            }
                        }
                    }

                    // 2. Delete related records & listing
                    using (SqlCommand cmd = new SqlCommand(@"
                        DELETE FROM ReplyNotifications WHERE ListingID = @ListingID;
                        DELETE FROM Payments WHERE ListingID = @ListingID;
                        DELETE FROM ListingRequests WHERE RequestedListingID = @ListingID OR ExchangeListingID = @ListingID;
                        DELETE FROM Listings WHERE ListingID = @ListingID;", con))
                    {
                        cmd.Parameters.AddWithValue("@ListingID", listingId);
                        cmd.ExecuteNonQuery();
                    }
                }

                // 3. Direct File System Cleanup: delete physical images from disk
                foreach (string imgPath in imagesToDelete)
                {
                    try
                    {
                        if (!string.IsNullOrEmpty(imgPath) && imgPath.StartsWith("~"))
                        {
                            string fullPath = Server.MapPath(imgPath);
                            if (File.Exists(fullPath))
                            {
                                File.Delete(fullPath);
                            }
                        }
                    }
                    catch { /* ignore cleanup error */ }
                }

                // Clear the hidden field and reload
                hfEditListingID.Value = string.Empty;
                lblMessage.Text = "Listing and associated images permanently deleted!";
                lblMessage.ForeColor = System.Drawing.Color.Green;
                BindListings();
            }
        }

        // Helper method for status badge CSS class
        public string GetStatusClass(string status)
        {
            if (string.IsNullOrEmpty(status))
                return string.Empty;

            switch (status.Trim().ToLower())
            {
                case "active":
                    return "status-active";
                case "sold":
                    return "status-sold";
                case "pending":
                    return "status-pending";
                default:
                    return string.Empty; // default or unknown status
            }
        }
    }
}
