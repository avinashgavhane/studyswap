using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace StudySwap.Student
{
    public partial class PaymentHistory : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["LIS"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserID"] == null)
                {
                    Response.Redirect("~/Login.aspx");
                    return;
                }

                LoadPaymentHistory();
            }
        }

        private void LoadPaymentHistory()
        {
            int userId = Convert.ToInt32(Session["UserID"]);
            DataTable dt = new DataTable();

            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT
                        p.PaymentID,
                        p.Amount,
                        p.PaymentMethod,
                        p.TransactionRef,
                        p.PaymentStatus,
                        p.PaymentDate,
                        l.Title AS ListingTitle
                    FROM Payments p
                    INNER JOIN Listings l ON p.ListingID = l.ListingID
                    WHERE p.PayerUserID = @UserID
                    ORDER BY p.PaymentDate DESC";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(dt);
                    }
                }
            }

            if (dt.Rows.Count > 0)
            {
                gvPayments.DataSource = dt;
                gvPayments.DataBind();
                pnlEmpty.Visible = false;
            }
            else
            {
                gvPayments.DataSource = null;
                gvPayments.DataBind();
                pnlEmpty.Visible = true;
            }
        }

        // Badge color based on payment status
        public string GetStatusClass(string status)
        {
            switch (status.ToLower())
            {
                case "success":
                case "completed":
                    return "badge-success";
                case "failed":
                    return "badge-danger";
                case "pending":
                    return "badge-warning";
                default:
                    return "badge-secondary";
            }
        }
    }
}
