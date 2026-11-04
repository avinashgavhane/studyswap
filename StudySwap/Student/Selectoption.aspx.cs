using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace StudySwap.Student
{
    public partial class Selectoption : Page
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
        private string GetListingType()
        {
            string type = "";
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string q = "SELECT ListingType FROM Listings WHERE ListingID=@ListingID";
                SqlCommand cmd = new SqlCommand(q, con);
                cmd.Parameters.AddWithValue("@ListingID", ListingID);

                con.Open();
                var result = cmd.ExecuteScalar();
                if (result != null)
                    type = result.ToString();
            }
            return type;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserID"] == null || ListingID == 0)
                {
                    Response.Redirect("BrowseItems.aspx");
                    return;
                }

                LoadMyListings();

                string listingType = GetListingType().ToLower();

                rblRequestType.Items.Clear();

                switch (listingType)
                {
                    case "both":
                        rblRequestType.Items.Add(new ListItem("Buy", "Buy"));
                        rblRequestType.Items.Add(new ListItem("Exchange", "Exchange"));
                        rblRequestType.SelectedIndex = 0; // Default selection: Buy
                        pnlExchange.Visible = false;
                        break;

                    case "sell":
                    case "buy":
                        rblRequestType.Items.Add(new ListItem("Buy", "Buy"));
                        rblRequestType.SelectedIndex = 0;
                        pnlExchange.Visible = false;
                        break;

                    case "exchange":
                        rblRequestType.Items.Add(new ListItem("Exchange", "Exchange"));
                        rblRequestType.SelectedIndex = 0;
                        pnlExchange.Visible = true;
                        break;

                    default:
                        // No valid type - hide options and show message
                        rblRequestType.Visible = false;
                        pnlExchange.Visible = false;
                        lblMsg.Text = "This listing type is not supported.";
                        lblMsg.Visible = true;
                        break;
                }
            }
        }


        protected void rblRequestType_SelectedIndexChanged(object sender, EventArgs e)
        {
            pnlExchange.Visible = rblRequestType.SelectedValue == "Exchange";
        }

        private void LoadMyListings()
        {
            ddlMyListings.Items.Clear();
            ddlMyListings.Items.Add(new System.Web.UI.WebControls.ListItem("-- Select Product --", ""));

            using (SqlConnection con = new SqlConnection(connStr))
            {
                string q = "SELECT ListingID, Title FROM Listings WHERE UserID=@UserID";
                SqlCommand cmd = new SqlCommand(q, con);
                cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);

                con.Open();
                var dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    ddlMyListings.Items.Add(
                        new System.Web.UI.WebControls.ListItem(
                            dr["Title"].ToString(),
                            dr["ListingID"].ToString()
                        ));
                }
            }
        }

        protected void btnContinue_Click(object sender, EventArgs e)
        {
            lblMsg.Visible = false;

            if (rblRequestType.SelectedValue == "Buy")
            {
                decimal price = GetListingPrice();

                Response.Redirect(
                    "Payment.aspx?ListingID=" + ListingID +
                    "&Price=" + price
                );
                return;
            }

            // EXCHANGE
            if (string.IsNullOrEmpty(ddlMyListings.SelectedValue))
            {
                lblMsg.Text = "Please select a product for exchange.";
                lblMsg.Visible = true;
                return;
            }

            SaveExchangeRequest();
        }
        private decimal GetListingPrice()
        {
            decimal price = 0;

            using (SqlConnection con = new SqlConnection(connStr))
            {
                string q = "SELECT SellingPrice FROM Listings WHERE ListingID=@ListingID";
                SqlCommand cmd = new SqlCommand(q, con);
                cmd.Parameters.AddWithValue("@ListingID", ListingID);

                con.Open();
                var result = cmd.ExecuteScalar();
                if (result != null)
                    decimal.TryParse(result.ToString(), out price);
            }

            return price;
        }
        private void SaveExchangeRequest()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string q = @"INSERT INTO ListingRequests
                            (RequestedListingID, RequesterStudentID, RequestType,
                             ExchangeListingID, RequestDate, Status)
                            VALUES
                            (@ReqListing, @UserID, 'Exchange',
                             @ExchangeID, GETDATE(), 'Pending')";

                SqlCommand cmd = new SqlCommand(q, con);
                cmd.Parameters.AddWithValue("@ReqListing", ListingID);
                cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);
                cmd.Parameters.AddWithValue("@ExchangeID", ddlMyListings.SelectedValue);

                con.Open();
                cmd.ExecuteNonQuery();
            }

            Response.Redirect("MyRequests.aspx");
        }
    }
}