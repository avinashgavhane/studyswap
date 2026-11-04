using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;

namespace StudySwap
{
    public partial class ForgotPassword : System.Web.UI.Page
    {
        private string _connStr = ConfigurationManager.ConnectionStrings["LIS"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                lblMessage.Visible = false;
            }
        }

        // ---- STEP 1: Verify Student Email + Roll Number ----
        protected void btnCheckEmail_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            string email = txtEmail.Text.Trim();
            string rollNumber = txtRollNumber.Text.Trim();

            if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(rollNumber))
            {
                ShowMessage("Please enter both your registered Email and College Roll Number.", false);
                return;
            }

            try
            {
                using (SqlConnection con = new SqlConnection(_connStr))
                {
                    con.Open();
                    string query = @"SELECT FullName 
                                     FROM Users 
                                     WHERE Email = @Email 
                                       AND RollNumber = @RollNumber";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@Email", email);
                        cmd.Parameters.AddWithValue("@RollNumber", rollNumber);

                        object result = cmd.ExecuteScalar();

                        if (result == null)
                        {
                            ShowMessage("Verification failed: No registered student found matching this Email and Roll Number.", false);
                            return;
                        }

                        string fullName = result.ToString();

                        // Verification passed: store verified email in hidden field
                        hfEmail.Value = email;
                        lblGreeting.Text = "Verified Student: <strong>" + Server.HtmlEncode(fullName) + "</strong> (" + Server.HtmlEncode(email) + ")";

                        // Transition to Step 2
                        pnlEmail.Visible = false;
                        pnlReset.Visible = true;
                        lblMessage.Visible = false;
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Database error: " + ex.Message, false);
            }
        }

        // ---- STEP 2: Hash & Save New Password ----
        protected void btnReset_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            string email = hfEmail.Value?.Trim();

            if (string.IsNullOrEmpty(email))
            {
                pnlReset.Visible = false;
                pnlEmail.Visible = true;
                ShowMessage("Session timed out. Please verify your Email and Roll Number again.", false);
                return;
            }

            string newPassword = txtNewPass.Text.Trim();
            if (newPassword.Length < 8)
            {
                ShowMessage("Password must be at least 8 characters long.", false);
                return;
            }

            string newHash = HashPassword(newPassword);

            try
            {
                using (SqlConnection con = new SqlConnection(_connStr))
                {
                    con.Open();

                    // Check existing password hash to prevent reusing the exact same password
                    string currentHash = null;
                    using (SqlCommand checkCmd = new SqlCommand("SELECT PasswordHash FROM Users WHERE Email = @Email", con))
                    {
                        checkCmd.Parameters.AddWithValue("@Email", email);
                        object o = checkCmd.ExecuteScalar();
                        if (o != null)
                        {
                            currentHash = o.ToString();
                        }
                    }

                    if (string.Equals(currentHash, newHash, StringComparison.OrdinalIgnoreCase))
                    {
                        ShowMessage("New password must be different from your current password.", false);
                        return;
                    }

                    // Update the student's password with the new SHA-256 hash
                    string updateQuery = @"UPDATE Users 
                                           SET PasswordHash = @Hash, 
                                               LastModified = GETDATE() 
                                           WHERE Email = @Email";

                    using (SqlCommand updateCmd = new SqlCommand(updateQuery, con))
                    {
                        updateCmd.Parameters.AddWithValue("@Hash", newHash);
                        updateCmd.Parameters.AddWithValue("@Email", email);
                        updateCmd.ExecuteNonQuery();
                    }
                }

                // Complete reset flow
                pnlReset.Visible = false;
                pnlEmail.Visible = false;
                ShowMessage("Success! Your password has been updated securely. You can now <a href='Login.aspx' style='font-weight:600; text-decoration:underline;'>Login here</a>.", true);
            }
            catch (Exception ex)
            {
                ShowMessage("Password reset failed: " + ex.Message, false);
            }
        }

        // ---- Helpers ----
        private void ShowMessage(string msg, bool isSuccess)
        {
            lblMessage.Visible = true;
            lblMessage.Text = msg;
            lblMessage.CssClass = "fp-msg " + (isSuccess ? "fp-ok" : "fp-err");
        }

        // SHA-256 Hex string hasher
        private string HashPassword(string plainPassword)
        {
            using (SHA256 sha = SHA256.Create())
            {
                byte[] bytes = sha.ComputeHash(Encoding.UTF8.GetBytes(plainPassword));
                StringBuilder sb = new StringBuilder();
                foreach (byte b in bytes)
                {
                    sb.Append(b.ToString("x2"));
                }
                return sb.ToString();
            }
        }
    }
}
