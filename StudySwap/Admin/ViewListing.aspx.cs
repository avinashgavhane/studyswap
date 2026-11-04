using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace StudySwap.Admin
{
    public partial class ViewListing : System.Web.UI.Page
    {
        private string ConnStr =>
            ConfigurationManager.ConnectionStrings["LIS"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindCategories();
                BindCourses();
                BindListings();
            }
        }

        #region Dropdown loaders

        private void BindCategories()
        {
            using (SqlConnection con = new SqlConnection(ConnStr))
            {
                string q = @"SELECT [CategoryID],[CategoryName]
                             FROM [StudySwap].[dbo].[Categories]
                             WHERE [IsActive] = 1
                             ORDER BY [CategoryName]";

                using (SqlDataAdapter da = new SqlDataAdapter(q, con))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    // Filter dropdown
                    ddlCategoryFilter.DataSource = dt;
                    ddlCategoryFilter.DataTextField = "CategoryName";
                    ddlCategoryFilter.DataValueField = "CategoryID";
                    ddlCategoryFilter.DataBind();
                    ddlCategoryFilter.Items.Insert(0, new ListItem("All Categories", ""));

                    // Edit modal dropdown
                    ddlEditCategory.DataSource = dt.Copy();
                    ddlEditCategory.DataTextField = "CategoryName";
                    ddlEditCategory.DataValueField = "CategoryID";
                    ddlEditCategory.DataBind();
                    ddlEditCategory.Items.Insert(0, new ListItem("-- Select --", ""));
                }
            }
        }

        private void BindCourses()
        {
            using (SqlConnection con = new SqlConnection(ConnStr))
            {
                string q = @"SELECT [CourseID],[CourseName]
                             FROM [StudySwap].[dbo].[Courses]
                             WHERE [IsActive] = 1
                             ORDER BY [CourseName]";

                using (SqlDataAdapter da = new SqlDataAdapter(q, con))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    ddlEditCourse.DataSource = dt;
                    ddlEditCourse.DataTextField = "CourseName";
                    ddlEditCourse.DataValueField = "CourseID";
                    ddlEditCourse.DataBind();
                    ddlEditCourse.Items.Insert(0, new ListItem("-- None --", ""));
                }
            }
        }

        #endregion

        #region Bind grid

        private void BindListings()
        {
            string search = txtSearch.Text.Trim();
            string category = ddlCategoryFilter.SelectedValue;
            string status = ddlStatusFilter.SelectedValue;
            string type = ddlTypeFilter.SelectedValue;

            string query = @"
                SELECT TOP (1000)
                       l.[ListingID], l.[UserID], l.[CategoryID], l.[CourseID],
                       l.[Title], l.[Description], l.[Condition], l.[ListingType],
                       l.[SellingPrice], l.[IsPriceNegotiable], l.[Status],
                       l.[ViewsCount], l.[PostedDate], l.[LastModified],
                       l.[Image1Path], l.[Image2Path], l.[Image3Path], l.[ReplyID],
                       u.[FullName]      AS SellerName,
                       cat.[CategoryName] AS CategoryName,
                       c.[CourseName]    AS CourseName
                  FROM [StudySwap].[dbo].[Listings] l
                  LEFT JOIN [StudySwap].[dbo].[Users]      u   ON l.[UserID]     = u.[UserID]
                  LEFT JOIN [StudySwap].[dbo].[Categories] cat ON l.[CategoryID] = cat.[CategoryID]
                  LEFT JOIN [StudySwap].[dbo].[Courses]    c   ON l.[CourseID]   = c.[CourseID]
                 WHERE 1 = 1";

            if (!string.IsNullOrEmpty(search))
                query += " AND (l.[Title] LIKE @q OR l.[Description] LIKE @q)";
            if (!string.IsNullOrEmpty(category))
                query += " AND l.[CategoryID] = @cat";
            if (!string.IsNullOrEmpty(status))
                query += " AND l.[Status] = @status";
            if (!string.IsNullOrEmpty(type))
                query += " AND l.[ListingType] = @type";

            query += " ORDER BY l.[ListingID] DESC";

            using (SqlConnection con = new SqlConnection(ConnStr))
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                if (!string.IsNullOrEmpty(search))
                    cmd.Parameters.AddWithValue("@q", "%" + search + "%");
                if (!string.IsNullOrEmpty(category))
                    cmd.Parameters.AddWithValue("@cat", Convert.ToInt32(category));
                if (!string.IsNullOrEmpty(status))
                    cmd.Parameters.AddWithValue("@status", status);
                if (!string.IsNullOrEmpty(type))
                    cmd.Parameters.AddWithValue("@type", type);

                using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    gvListings.DataSource = dt;
                    gvListings.DataBind();
                }
            }
        }

        #endregion

        #region Helpers

        public string GetStatusBadgeClass(object status)
        {
            string s = (status ?? "").ToString().ToLower();
            switch (s)
            {
                case "active": return "badge badge-active";
                case "pending": return "badge badge-pending";
                case "sold": return "badge badge-sold";
                case "removed": return "badge badge-removed";
                default: return "badge badge-draft";
            }
        }

        #endregion

        #region Filter

        protected void btnFilter_Click(object sender, EventArgs e)
        {
            gvListings.PageIndex = 0;
            BindListings();
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            ddlCategoryFilter.SelectedIndex = 0;
            ddlStatusFilter.SelectedIndex = 0;
            ddlTypeFilter.SelectedIndex = 0;
            gvListings.PageIndex = 0;
            BindListings();
        }

        #endregion

        #region GridView events

        protected void gvListings_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvListings.PageIndex = e.NewPageIndex;
            BindListings();
        }

        protected void gvListings_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditListing")
            {
                int listingId = Convert.ToInt32(e.CommandArgument);
                LoadListingIntoModal(listingId);
                ClientScript.RegisterStartupScript(this.GetType(), "openModal",
                    "openEditModal();", true);
            }
        }

        private void LoadListingIntoModal(int listingId)
        {
            using (SqlConnection con = new SqlConnection(ConnStr))
            {
                string q = @"
                    SELECT l.[ListingID], l.[Title], l.[Description], l.[Condition],
                           l.[ListingType], l.[SellingPrice], l.[IsPriceNegotiable],
                           l.[Status], l.[ViewsCount], l.[CategoryID], l.[CourseID],
                           l.[Image1Path], l.[Image2Path], l.[Image3Path],
                           u.[FullName] AS SellerName
                      FROM [StudySwap].[dbo].[Listings] l
                      LEFT JOIN [StudySwap].[dbo].[Users] u ON l.[UserID] = u.[UserID]
                     WHERE l.[ListingID] = @ListingID";

                using (SqlCommand cmd = new SqlCommand(q, con))
                {
                    cmd.Parameters.AddWithValue("@ListingID", listingId);
                    con.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            hfEditListingID.Value = dr["ListingID"].ToString();
                            txtEditTitle.Text = dr["Title"] as string ?? "";
                            txtEditDescription.Text = dr["Description"] as string ?? "";
                            txtEditSeller.Text = dr["SellerName"] as string ?? "(unknown)";
                            txtEditViews.Text = dr["ViewsCount"].ToString();
                            txtEditPrice.Text = dr["SellingPrice"] == DBNull.Value
                                                        ? ""
                                                        : Convert.ToDecimal(dr["SellingPrice"]).ToString("0.##");
                            chkEditNegotiable.Checked = dr["IsPriceNegotiable"] != DBNull.Value
                                                          && Convert.ToBoolean(dr["IsPriceNegotiable"]);

                            SetDropdown(ddlEditCondition, dr["Condition"].ToString());
                            SetDropdown(ddlEditType, dr["ListingType"].ToString());
                            SetDropdown(ddlEditStatus, dr["Status"].ToString());
                            SetDropdown(ddlEditCategory, dr["CategoryID"].ToString());
                            SetDropdown(ddlEditCourse, dr["CourseID"].ToString());

                            // Preview images
                            string p1 = dr["Image1Path"] as string;
                            string p2 = dr["Image2Path"] as string;
                            string p3 = dr["Image3Path"] as string;

                            imgPrev1.Visible = !string.IsNullOrEmpty(p1);
                            imgPrev2.Visible = !string.IsNullOrEmpty(p2);
                            imgPrev3.Visible = !string.IsNullOrEmpty(p3);
                            if (imgPrev1.Visible) imgPrev1.ImageUrl = ResolveUrl(p1);
                            if (imgPrev2.Visible) imgPrev2.ImageUrl = ResolveUrl(p2);
                            if (imgPrev3.Visible) imgPrev3.ImageUrl = ResolveUrl(p3);
                        }
                    }
                }
            }
        }

        private void SetDropdown(DropDownList ddl, string value)
        {
            if (string.IsNullOrEmpty(value)) return;
            ListItem item = ddl.Items.FindByValue(value);
            if (item != null)
            {
                ddl.ClearSelection();
                item.Selected = true;
            }
        }


        #endregion

        #region Update



        #endregion
    }
}