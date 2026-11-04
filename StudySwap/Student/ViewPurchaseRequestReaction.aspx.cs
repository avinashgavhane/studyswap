using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace StudySwap.Student
{
    public partial class ViewPurchaseRequestReaction : System.Web.UI.Page
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

        private void LoadMyPurchaseRequests()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"
        SELECT PurchaseRequestID, ItemName, Description, Status
        FROM PurchaseRequests
        WHERE RequesterUserID = @UserID
          AND (Reaction IS NULL OR Reaction <> 'Purchased')
        ORDER BY CreatedDate DESC";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);

                con.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.HasRows)
                {
                    rptRequests.DataSource = reader;
                    rptRequests.DataBind();
                    lblNoRequests.Visible = false;
                }
                else
                {
                    rptRequests.DataSource = null;
                    rptRequests.DataBind();
                    lblNoRequests.Visible = true;
                }
                con.Close();
            }
        }
        // Helper method for toggling edit mode
        protected bool IsEditing(RepeaterItem container)
        {
            if (ViewState["EditingRequestID"] == null) return false;
            int editingId = (int)ViewState["EditingRequestID"];
            int currentId = Convert.ToInt32(DataBinder.Eval(container.DataItem, "PurchaseRequestID"));
            return editingId == currentId;
        }

        // Set ddlStatusEdit selected value on ItemDataBound
        protected void rptRequests_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                if (IsEditing(e.Item))
                {
                    DropDownList ddlStatusEdit = (DropDownList)e.Item.FindControl("ddlStatusEdit");
                    string status = DataBinder.Eval(e.Item.DataItem, "Status").ToString();
                    ddlStatusEdit.SelectedValue = status;
                }
            }
        }

        protected void rptRequests_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int requestId = 0;

            // Parse CommandArgument only for commands other than CancelEdit (which has no argument)
            if (e.CommandName != "CancelEdit")
            {
                if (!int.TryParse(e.CommandArgument?.ToString(), out requestId))
                {
                    // Invalid CommandArgument — ignore or handle as needed
                    return;
                }
            }

            if (e.CommandName == "ViewReplies")
            {
                int purchaseRequestID = Convert.ToInt32(e.CommandArgument);

                // Get first ListingID for this PurchaseRequestID (ReplyID)
                int listingId = GetFirstListingIDForRequest(purchaseRequestID);

                if (e.CommandName == "ViewReplies")
                {
                  
                    Response.Redirect($"PurchaseRepliesList.aspx?RequestID={purchaseRequestID}");
                }
                else
                {
                    // No listing found for this request
                    // You can show a message or redirect back with a notification
                    // For example:
                    ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('No product replies found for this request.');", true);
                }
            }
            else if (e.CommandName == "EditRequest")
            {
                ViewState["EditingRequestID"] = requestId;
                LoadMyPurchaseRequests();
            }
            else if (e.CommandName == "CancelEdit")
            {
                ViewState["EditingRequestID"] = null;
                LoadMyPurchaseRequests();
            }
            else if (e.CommandName == "SaveRequest")
            {
                RepeaterItem item = e.Item;

                TextBox txtItemNameEdit = (TextBox)item.FindControl("txtItemNameEdit");
                TextBox txtDescriptionEdit = (TextBox)item.FindControl("txtDescriptionEdit");
                DropDownList ddlStatusEdit = (DropDownList)item.FindControl("ddlStatusEdit");

                if (string.IsNullOrWhiteSpace(txtItemNameEdit.Text) || string.IsNullOrWhiteSpace(txtDescriptionEdit.Text))
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Item Name and Description cannot be empty.');", true);
                    return;
                }

                using (SqlConnection con = new SqlConnection(connStr))
                {
                    string query = @"
                UPDATE PurchaseRequests
                SET ItemName = @ItemName,
                    Description = @Description,
                    Status = @Status
                WHERE PurchaseRequestID = @RequestID AND RequesterUserID = @UserID";

                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@ItemName", txtItemNameEdit.Text.Trim());
                    cmd.Parameters.AddWithValue("@Description", txtDescriptionEdit.Text.Trim());
                    cmd.Parameters.AddWithValue("@Status", ddlStatusEdit.SelectedValue);
                    cmd.Parameters.AddWithValue("@RequestID", requestId);
                    cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);

                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();
                }

                ViewState["EditingRequestID"] = null;
                LoadMyPurchaseRequests();
            }
            else if (e.CommandName == "DeleteRequest")
            {
                rptRequests.Visible = true;
                DeletePurchaseRequest(requestId);
                LoadMyPurchaseRequests();
            }
        }
        private int GetFirstListingIDForRequest(int purchaseRequestID)
        {
            int listingId = 0;
            string connStr = ConfigurationManager.ConnectionStrings["LIS"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = "SELECT TOP 1 ListingID FROM Listings WHERE ReplyID = @ReplyID AND Status = 'Active' ORDER BY PostedDate DESC";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@ReplyID", purchaseRequestID);
                    con.Open();

                    object result = cmd.ExecuteScalar();
                    if (result != null && int.TryParse(result.ToString(), out listingId))
                    {
                        return listingId;
                    }
                }
            }
            return listingId; // 0 means not found
        }

            private void DeletePurchaseRequest(int requestId)
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = "DELETE FROM PurchaseRequests WHERE PurchaseRequestID = @RequestID AND RequesterUserID = @UserID";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@RequestID", requestId);
                cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);

                con.Open();
                cmd.ExecuteNonQuery();
                con.Close();
            }
        }
    }
}
