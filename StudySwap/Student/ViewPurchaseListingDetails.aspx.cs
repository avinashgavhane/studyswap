using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace StudySwap.Student
{
    public partial class ViewPurchaseListingDetails : System.Web.UI.Page
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
                LoadMyPurchaseRequests();
            }
        }

        // ============================================
        // LOAD MY PURCHASE REQUESTS
        // ============================================
        private void LoadMyPurchaseRequests()
        {
            int userId = Convert.ToInt32(Session["UserID"]);

            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT 
                        pr.PurchaseRequestID,
                        pr.RequesterUserID,
                        pr.ItemName,
                        pr.CategoryID,
                        pr.Description,
                        pr.Status,
                        pr.Reaction,
                        pr.CreatedDate,
                        c.CategoryName
                    FROM PurchaseRequests pr
                    INNER JOIN Categories c ON pr.CategoryID = c.CategoryID
                    WHERE pr.RequesterUserID = @UserID
                    ORDER BY pr.CreatedDate DESC";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        lblRequestCount.Text = dt.Rows.Count.ToString();

                        if (dt.Rows.Count > 0)
                        {
                            rptRequests.DataSource = dt;
                            rptRequests.DataBind();
                            rptRequests.Visible = true;
                            pnlNoRequests.Visible = false;
                        }
                        else
                        {
                            rptRequests.Visible = false;
                            pnlNoRequests.Visible = true;
                        }
                    }
                }
            }
        }

        // ============================================
        // EDIT MODE HELPER
        // ============================================
        protected bool IsEditing(RepeaterItem container)
        {
            if (ViewState["EditingRequestID"] == null) return false;
            int editingId = Convert.ToInt32(ViewState["EditingRequestID"]);
            int currentId = Convert.ToInt32(DataBinder.Eval(container.DataItem, "PurchaseRequestID"));
            return editingId == currentId;
        }

        // ============================================
        // ITEM DATA BOUND — Set dropdown values + categories
        // ============================================
        protected void rptRequests_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                if (IsEditing(e.Item))
                {
                    // 1. Load categories into ddlCategoryEdit
                    DropDownList ddlCategoryEdit = (DropDownList)e.Item.FindControl("ddlCategoryEdit");
                    if (ddlCategoryEdit != null)
                    {
                        LoadCategoriesIntoDropdown(ddlCategoryEdit);

                        // Select current category
                        int currentCatId = Convert.ToInt32(DataBinder.Eval(e.Item.DataItem, "CategoryID"));
                        ListItem li = ddlCategoryEdit.Items.FindByValue(currentCatId.ToString());
                        if (li != null) li.Selected = true;
                    }

                    // 2. Set status
                    DropDownList ddlStatusEdit = (DropDownList)e.Item.FindControl("ddlStatusEdit");
                    if (ddlStatusEdit != null)
                    {
                        string status = DataBinder.Eval(e.Item.DataItem, "Status").ToString();
                        ListItem li = ddlStatusEdit.Items.FindByValue(status);
                        if (li != null) li.Selected = true;
                    }
                }
            }
        }

        // ============================================
        // LOAD CATEGORIES INTO A DROPDOWN
        // ============================================
        private void LoadCategoriesIntoDropdown(DropDownList ddl)
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = "SELECT CategoryID, CategoryName FROM Categories WHERE IsActive = 1 ORDER BY DisplayOrder";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    con.Open();
                    using (SqlDataReader rdr = cmd.ExecuteReader())
                    {
                        ddl.DataSource = rdr;
                        ddl.DataTextField = "CategoryName";
                        ddl.DataValueField = "CategoryID";
                        ddl.DataBind();
                    }
                }
            }
        }

        // ============================================
        // ITEM COMMAND — Edit / Delete / Save / Cancel
        // ============================================
        protected void rptRequests_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int requestId = 0;

            if (e.CommandName != "CancelEdit")
            {
                if (!int.TryParse(e.CommandArgument?.ToString(), out requestId))
                    return;
            }

            switch (e.CommandName)
            {
                case "EditRequest":
                    ViewState["EditingRequestID"] = requestId;
                    LoadMyPurchaseRequests();
                    break;

                case "CancelEdit":
                    ViewState["EditingRequestID"] = null;
                    LoadMyPurchaseRequests();
                    break;

                case "SaveRequest":
                    SaveRequest(e, requestId);
                    break;

                case "DeleteRequest":
                    DeleteRequest(requestId);
                    break;
            }
        }

        // ============================================
        // SAVE EDITED REQUEST
        // ============================================
        private void SaveRequest(RepeaterCommandEventArgs e, int requestId)
        {
            RepeaterItem item = e.Item;

            TextBox txtItemNameEdit = (TextBox)item.FindControl("txtItemNameEdit");
            DropDownList ddlCategoryEdit = (DropDownList)item.FindControl("ddlCategoryEdit");
            TextBox txtDescriptionEdit = (TextBox)item.FindControl("txtDescriptionEdit");
            DropDownList ddlStatusEdit = (DropDownList)item.FindControl("ddlStatusEdit");

            // Validation
            if (string.IsNullOrWhiteSpace(txtItemNameEdit.Text) ||
                string.IsNullOrWhiteSpace(txtDescriptionEdit.Text) ||
                ddlCategoryEdit.SelectedValue == "")
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert",
                    "alert('Item Name, Category, and Description cannot be empty.');", true);
                return;
            }

            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"
                    UPDATE PurchaseRequests
                    SET ItemName = @ItemName,
                        CategoryID = @CategoryID,
                        Description = @Description,
                        Status = @Status
                    WHERE PurchaseRequestID = @RequestID
                      AND RequesterUserID = @UserID";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@ItemName", txtItemNameEdit.Text.Trim());
                    cmd.Parameters.AddWithValue("@CategoryID", ddlCategoryEdit.SelectedValue);
                    cmd.Parameters.AddWithValue("@Description", txtDescriptionEdit.Text.Trim());
                    cmd.Parameters.AddWithValue("@Status", ddlStatusEdit.SelectedValue);
                    cmd.Parameters.AddWithValue("@RequestID", requestId);
                    cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            // Exit edit mode + refresh
            ViewState["EditingRequestID"] = null;
            LoadMyPurchaseRequests();
        }

        // ============================================
        // DELETE REQUEST
        // ============================================
        private void DeleteRequest(int requestId)
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = "DELETE FROM PurchaseRequests WHERE PurchaseRequestID = @RequestID AND RequesterUserID = @UserID";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@RequestID", requestId);
                    cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            ViewState["EditingRequestID"] = null;
            LoadMyPurchaseRequests();
        }

        // ============================================
        // HELPERS (called from ASPX markup)
        // ============================================
        protected string GetStatusClass(string status)
        {
            if (string.IsNullOrEmpty(status)) return "status-deactive";
            return status.ToLower() == "active" ? "status-active" : "status-deactive";
        }
    }
}