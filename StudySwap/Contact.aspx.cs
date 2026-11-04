using System;
using System.Configuration;
using System.Data.SqlClient;

namespace StudySwap
{
    public partial class Contact : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Hide success panel on first load
            if (!IsPostBack)
            {
                pnlSuccess.Visible = false;
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            // Server-side validation
            if (!Page.IsValid)
                return;

            string connStr = ConfigurationManager.ConnectionStrings["LIS"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"
                    INSERT INTO ContactMessages
                    (Name, Email, Subject, Message, ReceivedDate,Mobile)
                    VALUES
                    (@Name, @Email, @Subject, @Message,  @ReceivedDate,@mobile)
                ";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Name", txtName.Text.Trim());
                    cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
                    cmd.Parameters.AddWithValue("@Subject", ddlSubject.SelectedValue);
                    cmd.Parameters.AddWithValue("@Message", txtMessage.Text.Trim());
                    cmd.Parameters.AddWithValue("@ReceivedDate", DateTime.Now);
                    cmd.Parameters.AddWithValue("@mobile", txtMobile.Text.Trim());

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            // Show success message
            pnlSuccess.Visible = true;

            // Clear form
            txtName.Text = "";
            txtEmail.Text = "";
            txtMobile.Text = "";
            ddlSubject.SelectedIndex = 0;
            txtMessage.Text = "";
        }
    }
}
