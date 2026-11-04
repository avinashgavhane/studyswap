using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;

namespace StudySwap
{
    public partial class Login : System.Web.UI.Page
    {
        string cs;

        protected void Page_Load(object sender, EventArgs e)
        {
            cs = ConfigurationManager.ConnectionStrings["LIS"].ConnectionString;
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            pnlError.Visible = false;

            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text.Trim();

            // First try ADMIN login
            if (AdminLogin(email, password))
                return;

            // Then try STUDENT login
            if (StudentLogin(email, password))
                return;

            // If both fail
            ShowError("Invalid email or password or Pending Account");
        }

        // ---------------- ADMIN LOGIN ----------------
        private bool AdminLogin(string username, string password)
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                string query = "SELECT * FROM AdminLogin WHERE username=@u AND password=@p";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@u", username);
                cmd.Parameters.AddWithValue("@p", password);

                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.Read())
                {
                    Session["Admin"] = username;
                    Response.Redirect("~/Admin/AdminDashboard.aspx");
                    return true;
                }
            }
            return false;
        }

        // ---------------- STUDENT LOGIN ----------------
        private bool StudentLogin(string email, string password)
        {
            string hashedPassword = HashPassword(password);

            using (SqlConnection con = new SqlConnection(cs))
            {
                string query = @"SELECT UserID, FullName 
                                 FROM Users 
                                 WHERE Email=@e AND PasswordHash=@p 
                                 AND IsVerified='1'";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@e", email);
                cmd.Parameters.AddWithValue("@p", hashedPassword);

                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.Read())
                {
                    Session["UserID"] = dr["UserID"];
                    Session["FullName"] = dr["FullName"];
                    Session["Role"] = "Student";

                    Response.Redirect("~/Student/StudentDashboard.aspx");
                    return true;
                }
            }
            return false;
        }

        // ---------------- PASSWORD HASH ----------------
        private string HashPassword(string password)
        {
            using (SHA256 sha = SHA256.Create())
            {
                byte[] bytes = sha.ComputeHash(Encoding.UTF8.GetBytes(password));
                StringBuilder sb = new StringBuilder();
                foreach (byte b in bytes)
                    sb.Append(b.ToString("x2"));
                return sb.ToString();
            }
        }

        private void ShowError(string msg)
        {
            pnlError.Visible = true;
            lblError.Text = msg;
        }
    }
}
