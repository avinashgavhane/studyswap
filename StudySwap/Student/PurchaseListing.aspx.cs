using System;
using System.Configuration;
using System.Data.SqlClient;

namespace StudySwap.Student
{
    public partial class PurchaseListing : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["LIS"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Check login
            if (Session["UserID"] == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadCategories();
            }
        }

        // 🔹 Load Category Dropdown
        private void LoadCategories()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = "SELECT CategoryID, CategoryName FROM Categories ORDER BY CategoryName";
                SqlCommand cmd = new SqlCommand(query, con);

                con.Open();
                ddlCategory.DataSource = cmd.ExecuteReader();
                ddlCategory.DataTextField = "CategoryName";
                ddlCategory.DataValueField = "CategoryID";
                ddlCategory.DataBind();
                con.Close();
            }

            ddlCategory.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- Select Category --", ""));
        }
        // 🔹 View My Purchase Requests

       

        // 🔹 Submit Purchase Request
        protected void btnSubmitRequest_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtItemName.Text) ||
                string.IsNullOrWhiteSpace(txtDescription.Text) ||
                ddlCategory.SelectedValue == "")
            {
                ClientScript.RegisterStartupScript(this.GetType(),
                    "alert", "alert('Please fill all required fields');", true);
                return;
            }

            int newRequestID;

            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"
            INSERT INTO PurchaseRequests
            (RequesterUserID, ItemName, CategoryID, Description, Status, CreatedDate)
            OUTPUT INSERTED.PurchaseRequestID
            VALUES
            (@UserID, @ItemName, @CategoryID, @Description, 'Active', GETDATE())";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);
                cmd.Parameters.AddWithValue("@ItemName", txtItemName.Text.Trim());
                cmd.Parameters.AddWithValue("@CategoryID", ddlCategory.SelectedValue);
                cmd.Parameters.AddWithValue("@Description", txtDescription.Text.Trim());

                con.Open();
                newRequestID = Convert.ToInt32(cmd.ExecuteScalar());
                con.Close();
            }

            // ✅ Store RequestID for button navigation
            Session["LastPurchaseRequestID"] = newRequestID;

            // Clear form
            txtItemName.Text = "";
            txtDescription.Text = "";
            ddlCategory.SelectedIndex = 0;

            ClientScript.RegisterStartupScript(this.GetType(),
                "success", "alert('Purchase request sent successfully!');", true);
        }

        protected void btnview_Click(object sender, EventArgs e)
        {
            Response.Redirect("ViewAllPurchaseRequest.aspx");
        }
    }
}
