using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace StudySwap.Student
{
    public partial class ListingDetails : System.Web.UI.Page
    {
        private string connStr = ConfigurationManager.ConnectionStrings["LIS"].ConnectionString;

        protected int ListingID
        {
            get
            {
                if (int.TryParse(Request.QueryString["ListingID"], out int id))
                    return id;
                return 0;
            }
        }
        protected void Thumbnail_Click(object sender, ImageClickEventArgs e)
        {
            ImageButton btn = (ImageButton)sender;
            imgMain.ImageUrl = btn.CommandArgument;
        }


    

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (ListingID == 0)
                {
                    Response.Redirect("BrowseItems.aspx");
                    return;
                }

                LoadListingDetails();
                //rptImages.DataSource = ListingImages;
                //rptImages.DataBind();
            }
        }

        private void LoadListingDetails()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"
                SELECT 
    L.Title, L.SellingPrice, L.Condition, L.Description, L.ListingType, L.PostedDate,
    L.Image1Path, L.Image2Path, L.Image3Path, 
    U.FullName, U.Email, U.Phone, U.ShowPhoneToVerified,
    Coll.CollegeName,
    Dept.DepartmentName, Dept.DepartmentCode,
    C.CourseName, C.CourseCode
FROM Listings L
INNER JOIN Users U ON L.UserID = U.UserID
LEFT JOIN Colleges Coll ON Coll.CollegeID = CAST(U.College AS INT)
LEFT JOIN Departments Dept ON Dept.DepartmentID = CAST(U.Department AS INT)
LEFT JOIN Courses C ON U.CourseID = C.CourseID
WHERE L.ListingID = @ListingID
";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@ListingID", ListingID);
                    con.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())

                        {
                            lblDepartment.Text = dr["DepartmentName"] != DBNull.Value
      ? dr["DepartmentName"].ToString() + " (" + dr["DepartmentCode"].ToString() + ")"
      : "N/A";

                            lblCourse.Text = dr["CourseName"] != DBNull.Value
                                ? dr["CourseName"].ToString() + " (" + dr["CourseCode"].ToString() + ")"
                                : "N/A";

                            lblStudentName.Text = dr["FullName"].ToString();
                            lblStudentEmail.Text = dr["Email"].ToString();
                            lblStudentMobile.Text = dr["Phone"].ToString();

                            lblStudentCollege.Text = dr["CollegeName"] != DBNull.Value
                                ? dr["CollegeName"].ToString()
                                : "N/A";

                            lblStudentName.Text = dr["FullName"].ToString();
                            lblStudentEmail.Text = dr["Email"].ToString();
                            lblStudentMobile.Text = dr["Phone"].ToString();

                            lblTitle.Text = dr["Title"].ToString();
                            lblPrice.Text = Convert.ToDecimal(dr["SellingPrice"]).ToString("C");
                            lblCondition.Text = dr["Condition"].ToString();
                            lblDescription.Text = dr["Description"].ToString();

                            bool allowChat = dr["ShowPhoneToVerified"] != DBNull.Value && Convert.ToBoolean(dr["ShowPhoneToVerified"]);
                            string phone = dr["Phone"] != DBNull.Value ? dr["Phone"].ToString().Trim() : "";
                            string title = dr["Title"] != DBNull.Value ? dr["Title"].ToString().Trim() : "";

                            if (lnkWhatsApp != null)
                            {
                                if (allowChat && !string.IsNullOrEmpty(phone))
                                {
                                    string cleanPhone = System.Text.RegularExpressions.Regex.Replace(phone, @"[^\d]", "");
                                    if (cleanPhone.Length == 10) cleanPhone = "91" + cleanPhone;
                                    string msg = Uri.EscapeDataString("Hi! I saw your listing for '" + title + "' on StudySwap. Is it still available?");
                                    lnkWhatsApp.NavigateUrl = "https://wa.me/" + cleanPhone + "?text=" + msg;
                                    lnkWhatsApp.Visible = true;
                                }
                                else
                                {
                                    lnkWhatsApp.Visible = false;
                                }
                            }
                            lblListingType.Text = dr["ListingType"].ToString();
                            if (lblListingType.Text.Equals("Both", StringComparison.OrdinalIgnoreCase))
                            {
                                lblListingType.Text = "Buy or Exchange";
                            }
                            lblPostedDate.Text = Convert.ToDateTime(dr["PostedDate"]).ToString("dd MMM yyyy");

                            string img1 = dr["Image1Path"] as string;
                            string img2 = dr["Image2Path"] as string;
                            string img3 = dr["Image3Path"] as string;

                            // MAIN IMAGE
                            imgMain.ImageUrl = !string.IsNullOrEmpty(img1)
                                ? ResolveUrl(img1)
                                : ResolveUrl("~/Images/no-image.png");

                            // THUMB 1
                            imgThumb1.ImageUrl = imgMain.ImageUrl;
                            imgThumb1.CommandArgument = imgMain.ImageUrl;

                            // THUMB 2
                            if (!string.IsNullOrEmpty(img2))
                            {
                                imgThumb2.Visible = true;
                                imgThumb2.ImageUrl = ResolveUrl(img2);
                                imgThumb2.CommandArgument = imgThumb2.ImageUrl;
                            }

                            // THUMB 3
                            if (!string.IsNullOrEmpty(img3))
                            {
                                imgThumb3.Visible = true;
                                imgThumb3.ImageUrl = ResolveUrl(img3);
                                imgThumb3.CommandArgument = imgThumb3.ImageUrl;
                            }

                        }
                        else
                        {
                            Response.Redirect("BrowseItems.aspx");
                        }
                    }
                }
            }
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("BrowseItems.aspx");
        }

        protected void btnSendRequest_Click(object sender, EventArgs e)
        {
            Response.Redirect("Selectoption.aspx?ListingID=" + ListingID);
        }


     



    }
}

