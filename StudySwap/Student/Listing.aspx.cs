using System;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace StudySwap.Student
{
    public partial class Listing : System.Web.UI.Page
    {
        string cs = ConfigurationManager.ConnectionStrings["LIS"].ConnectionString;

        int replyId = 0; // 🔹 Optional Purchase Reply ID

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // 🔐 Check login
                if (Session["UserID"] == null)
                {
                    Response.Redirect("~/Login.aspx");
                    return;
                }

                // 🔹 Read ReplyID if exists
                if (Request.QueryString["ReplyID"] != null)
                {
                    hfReplyID.Value = Request.QueryString["ReplyID"];
                }

                LoadCategories();
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            try
            {
                if (Session["UserID"] == null)
                {
                    ShowMessage("Please login to create a listing.", "error");
                    return;
                }

                // 🔹 Validate images
                if (!fuImage1.HasFile || !fuImage2.HasFile || !fuImage3.HasFile)
                {
                    ShowMessage("⚠️ Please upload all 3 product images.", "error");
                    return;
                }

                // 🔹 Validate required fields
                if (string.IsNullOrWhiteSpace(ddlCategory.SelectedValue) ||
                    string.IsNullOrWhiteSpace(txtTitle.Text) ||
                    string.IsNullOrWhiteSpace(txtDescription.Text) ||
                    string.IsNullOrWhiteSpace(ddlCondition.SelectedValue) ||
                    string.IsNullOrWhiteSpace(hfListingType.Value))
                {
                    ShowMessage("⚠️ Please fill in all required fields.", "error");
                    return;
                }

                string listingType = hfListingType.Value;
                decimal sellingPrice = 0;

                if (listingType == "Sell" || listingType == "Both")
                {
                    if (!decimal.TryParse(txtPrice.Text, out sellingPrice) || sellingPrice <= 0)
                    {
                        ShowMessage("⚠️ Please enter a valid selling price.", "error");
                        return;
                    }
                }

                int userId = Convert.ToInt32(Session["UserID"]);

                // 🔹 Upload folder
                string uploadFolder = Server.MapPath("~/Uploads/ListingImages/");
                if (!Directory.Exists(uploadFolder))
                {
                    Directory.CreateDirectory(uploadFolder);
                }

                string timestamp = DateTime.Now.ToString("yyyyMMddHHmmss");
                string[] imagePaths = new string[3];

                imagePaths[0] = SaveImage(fuImage1, uploadFolder, userId, 1, timestamp);
                imagePaths[1] = SaveImage(fuImage2, uploadFolder, userId, 2, timestamp);
                imagePaths[2] = SaveImage(fuImage3, uploadFolder, userId, 3, timestamp);

                if (imagePaths[0] == null || imagePaths[1] == null || imagePaths[2] == null)
                {
                    ShowMessage("⚠️ Image upload failed. Use JPG or PNG under 5MB.", "error");
                    return;
                }

                // 🔹 Insert listing
                using (SqlConnection con = new SqlConnection(cs))
                {
                    // 🔑 Added "; SELECT SCOPE_IDENTITY();" to retrieve the new ListingID
                    string query = @"INSERT INTO Listings
                        (UserID, CategoryID, ReplyID, Title, Description, [Condition],
                         ListingType, SellingPrice, IsPriceNegotiable, Status,
                         ViewsCount, PostedDate, LastModified,
                         Image1Path, Image2Path, Image3Path)
                    VALUES
                        (@UserID, @CategoryID, @ReplyID, @Title, @Description, @Condition,
                         @ListingType, @SellingPrice, @IsPriceNegotiable, 'Active',
                         0, GETDATE(), GETDATE(),
                         @Image1Path, @Image2Path, @Image3Path);
                    SELECT SCOPE_IDENTITY();";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        cmd.Parameters.AddWithValue("@CategoryID", ddlCategory.SelectedValue);

                        int replyId = 0;
                        int.TryParse(hfReplyID.Value, out replyId);

                        cmd.Parameters.AddWithValue("@ReplyID",
                            replyId > 0 ? (object)replyId : DBNull.Value);

                        cmd.Parameters.AddWithValue("@Title", txtTitle.Text.Trim());
                        cmd.Parameters.AddWithValue("@Description", txtDescription.Text.Trim());
                        cmd.Parameters.AddWithValue("@Condition", ddlCondition.SelectedValue);
                        cmd.Parameters.AddWithValue("@ListingType", listingType);
                        cmd.Parameters.AddWithValue("@SellingPrice", sellingPrice);
                        cmd.Parameters.AddWithValue("@IsPriceNegotiable", chkNegotiable.Checked);
                        cmd.Parameters.AddWithValue("@Image1Path", imagePaths[0]);
                        cmd.Parameters.AddWithValue("@Image2Path", imagePaths[1]);
                        cmd.Parameters.AddWithValue("@Image3Path", imagePaths[2]);

                        con.Open();

                        // ExecuteScalar returns the new ListingID
                        object newIdObj = cmd.ExecuteScalar();
                        int newListingId = newIdObj != null
                            ? Convert.ToInt32(newIdObj)
                            : 0;

                        if (newListingId > 0)
                        {
                            // 🔔 If this listing is a reply to a PurchaseRequest, notify the requester
                            if (replyId > 0)
                            {
                                try
                                {
                                    // Get the requester's UserID from PurchaseRequests
                                    int requesterId = 0;
                                    using (SqlCommand cmdReq = new SqlCommand(
                                        @"SELECT RequesterUserID 
                                          FROM PurchaseRequests 
                                          WHERE PurchaseRequestID = @PRID", con))
                                    {
                                        cmdReq.Parameters.AddWithValue("@PRID", replyId);
                                        object r = cmdReq.ExecuteScalar();
                                        if (r != null && r != DBNull.Value)
                                            requesterId = Convert.ToInt32(r);
                                    }

                                    // Insert notification (skip if replier == requester)
                                    if (requesterId > 0 && requesterId != userId)
                                    {
                                        using (SqlCommand cmdNotif = new SqlCommand(
                                            @"INSERT INTO ReplyNotifications 
                                              (UserID, ListingID, PurchaseRequestID, IsRead, CreatedDate)
                                              VALUES (@UserID, @ListingID, @PRID, 0, GETDATE())", con))
                                        {
                                            cmdNotif.Parameters.AddWithValue("@UserID", requesterId);
                                            cmdNotif.Parameters.AddWithValue("@ListingID", newListingId);
                                            cmdNotif.Parameters.AddWithValue("@PRID", replyId);
                                            cmdNotif.ExecuteNonQuery();
                                        }
                                    }
                                }
                                catch
                                {
                                    // Notification failure is non-critical — listing was already created
                                }
                            }

                            ShowMessage("✅ Listing created successfully!", "success");
                            ClearForm();
                        }
                        else
                        {
                            ShowMessage("❌ Failed to create listing.", "error");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("❌ Error: " + ex.Message, "error");
            }
        }

        private string SaveImage(FileUpload fu, string folder, int userId, int index, string timestamp)
        {
            try
            {
                string ext = Path.GetExtension(fu.FileName).ToLower();
                if (ext != ".jpg" && ext != ".jpeg" && ext != ".png")
                    return null;

                if (fu.PostedFile.ContentLength > 5 * 1024 * 1024)
                    return null;

                string fileName = $"User_{userId}_Listing_{timestamp}_Img{index}{ext}";
                string fullPath = Path.Combine(folder, fileName);

                fu.SaveAs(fullPath);
                return "~/Uploads/ListingImages/" + fileName;
            }
            catch
            {
                return null;
            }
        }

        private void LoadCategories()
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                string query = "SELECT CategoryID, CategoryName FROM Categories WHERE IsActive = 1";
                SqlCommand cmd = new SqlCommand(query, con);
                con.Open();
                ddlCategory.DataSource = cmd.ExecuteReader();
                ddlCategory.DataTextField = "CategoryName";
                ddlCategory.DataValueField = "CategoryID";
                ddlCategory.DataBind();
                ddlCategory.Items.Insert(0, new ListItem("-- Select Category --", ""));
            }
        }

        private void ShowMessage(string message, string type)
        {
            pnlMessage.Visible = true;
            lblMessage.Text = message;
            pnlMessage.CssClass = type == "success"
                ? "alert alert-success"
                : "alert alert-danger";
        }

        private void ClearForm()
        {
            ddlCategory.SelectedIndex = 0;
            txtTitle.Text = "";
            txtDescription.Text = "";
            ddlCondition.SelectedIndex = 0;
            txtPrice.Text = "";
            chkNegotiable.Checked = false;
            hfListingType.Value = "";
        }
    }
}