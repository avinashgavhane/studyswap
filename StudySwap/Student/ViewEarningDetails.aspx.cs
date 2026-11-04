using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace StudySwap.Student
{
    public partial class ViewEarningDetails : System.Web.UI.Page
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
                LoadSummary();
                LoadEarnings();
            }
        }

        // ============================================
        // SUMMARY CARDS — Total / Count / Avg / Last
        // ============================================
        private void LoadSummary()
        {
            int sellerId = Convert.ToInt32(Session["UserID"]);

            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();

                // Total Earned + Items Sold + Last Sale Date (single query)
                string query = @"
                    SELECT 
                        ISNULL(SUM(p.Amount), 0) AS TotalEarned,
                        COUNT(*) AS TotalSales,
                        MAX(p.PaymentDate) AS LastSaleDate
                    FROM Payments p
                    INNER JOIN Listings l ON p.ListingID = l.ListingID
                    WHERE l.UserID = @SellerID
                      AND p.PayerUserID <> @SellerID
                      AND p.PaymentStatus IN ('Success','Completed')";

                decimal totalEarned = 0;
                int totalSales = 0;
                object lastSale = null;

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@SellerID", sellerId);
                    using (SqlDataReader rdr = cmd.ExecuteReader())
                    {
                        if (rdr.Read())
                        {
                            totalEarned = Convert.ToDecimal(rdr["TotalEarned"]);
                            totalSales = Convert.ToInt32(rdr["TotalSales"]);
                            lastSale = rdr["LastSaleDate"];
                        }
                    }
                }

                // Set values
                lblHeaderTotal.Text = totalEarned.ToString("N0");
                lblTotalEarned.Text = totalEarned.ToString("N0");
                lblTotalSales.Text = totalSales.ToString();

                decimal avg = totalSales > 0 ? totalEarned / totalSales : 0;
                lblAvgEarning.Text = avg.ToString("N0");

                lblLastEarningDate.Text = (lastSale != null && lastSale != DBNull.Value)
                    ? Convert.ToDateTime(lastSale).ToString("dd MMM")
                    : "—";
            }
        }

        // ============================================
        // EARNINGS TABLE — Seller's sales only
        // ============================================
        private void LoadEarnings()
        {
            int sellerId = Convert.ToInt32(Session["UserID"]);

            string query = @"
                SELECT 
                    p.PaymentID,
                    p.Amount,
                    p.PaymentMethod,
                    p.TransactionRef,
                    p.PaymentStatus,
                    p.PaymentDate,
                    p.ListingID,
                    l.Title AS ListingTitle,
                    u.FullName AS BuyerName
                FROM Payments p
                INNER JOIN Listings l ON p.ListingID = l.ListingID
                INNER JOIN Users u ON p.PayerUserID = u.UserID
                WHERE l.UserID = @SellerID
                  AND p.PayerUserID <> @SellerID
                  AND p.PaymentStatus IN ('Success','Completed')";

            // Optional date filters
            if (!string.IsNullOrEmpty(txtFromDate.Text))
                query += " AND p.PaymentDate >= @FromDate";
            if (!string.IsNullOrEmpty(txtToDate.Text))
                query += " AND p.PaymentDate < @ToDate";

            query += " ORDER BY p.PaymentDate DESC";

            using (SqlConnection con = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@SellerID", sellerId);

                    if (!string.IsNullOrEmpty(txtFromDate.Text))
                        cmd.Parameters.AddWithValue("@FromDate", Convert.ToDateTime(txtFromDate.Text));

                    if (!string.IsNullOrEmpty(txtToDate.Text))
                        cmd.Parameters.AddWithValue("@ToDate", Convert.ToDateTime(txtToDate.Text).AddDays(1));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        lblRecordCount.Text = dt.Rows.Count.ToString();

                        if (dt.Rows.Count > 0)
                        {
                            rptEarnings.DataSource = dt;
                            rptEarnings.DataBind();
                            rptEarnings.Visible = true;
                            pnlEmpty.Visible = false;
                        }
                        else
                        {
                            rptEarnings.Visible = false;
                            pnlEmpty.Visible = true;
                        }
                    }
                }
            }
        }

        // ============================================
        // BUTTON HANDLERS
        // ============================================
        protected void btnFilter_Click(object sender, EventArgs e)
        {
            LoadEarnings();
            LoadSummary();
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            txtFromDate.Text = "";
            txtToDate.Text = "";
            LoadEarnings();
            LoadSummary();
        }

        // ============================================
        // HELPERS (called from ASPX markup)
        // ============================================
        protected string GetInitials(string fullName)
        {
            if (string.IsNullOrWhiteSpace(fullName)) return "?";
            var parts = fullName.Trim().Split(' ');
            if (parts.Length == 1) return parts[0].Substring(0, 1).ToUpper();
            return (parts[0].Substring(0, 1) + parts[parts.Length - 1].Substring(0, 1)).ToUpper();
        }

        protected string GetMethodIcon(string method)
        {
            if (string.IsNullOrEmpty(method)) return "credit-card";
            switch (method.ToLower())
            {
                case "online": return "globe";
                case "demopayment": return "flask";
                case "cash": return "money-bill-wave";
                case "upi": return "mobile-alt";
                case "card": return "credit-card";
                default: return "credit-card";
            }
        }

        protected string GetStatusClass(string status)
        {
            if (string.IsNullOrEmpty(status)) return "badge-warning";
            switch (status.ToLower())
            {
                case "completed":
                case "success":
                    return "badge-success";
                case "pending":
                    return "badge-warning";
                case "failed":
                case "cancelled":
                    return "badge-danger";
                default:
                    return "badge-warning";
            }
        }
    }
}