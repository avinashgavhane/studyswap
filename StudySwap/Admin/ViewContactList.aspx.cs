using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace StudySwap.Admin
{
    public partial class ViewContactList : System.Web.UI.Page
    {
        string cs = ConfigurationManager.ConnectionStrings["LIS"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadMessages();
            }
        }

        // ============================================
        // LOAD ALL CONTACT MESSAGES
        // ============================================
        private void LoadMessages()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    string query = @"
                        SELECT TOP (1000) 
                            [MessageID],
                            [Name],
                            [Email],
                            [Mobile],
                            [Subject],
                            [Message],
                            [Status],
                            [AdminResponse],
                            [RespondedBy],
                            [ReceivedDate],
                            [ResponseDate]
                        FROM [StudySwap].[dbo].[ContactMessages]
                        ORDER BY [ReceivedDate] DESC";

                    SqlDataAdapter da = new SqlDataAdapter(query, con);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    rptMessages.DataSource = dt;
                    rptMessages.DataBind();
                }
            }
            catch (Exception ex)
            {
                lblAlert.Text = "⚠ Error loading messages: " + ex.Message;
                pnlAlert.Visible = true;
            }
        }

        // ============================================
        // REFRESH BUTTON
        // ============================================
        protected void btnRefresh_Click(object sender, EventArgs e)
        {
            LoadMessages();
            lblAlert.Text = "✓ List refreshed successfully.";
            pnlAlert.Visible = true;
        }

        // ============================================
        // REPEATER ITEM COMMAND (View + Delete)
        // ============================================
        protected void rptMessages_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "ViewMsg")
            {
                int messageId = Convert.ToInt32(e.CommandArgument);
                LoadMessageIntoModal(messageId);
            }
            // ✅ NEW: Handle Delete command
            else if (e.CommandName == "DeleteMsg")
            {
                int messageId = Convert.ToInt32(e.CommandArgument);
                DeleteMessage(messageId);
            }
        }

        // ============================================
        // ✅ NEW: DELETE MESSAGE
        // ============================================
        private void DeleteMessage(int messageId)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    string query = @"
                        DELETE FROM [StudySwap].[dbo].[ContactMessages]
                        WHERE [MessageID] = @ID";

                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@ID", messageId);

                    con.Open();
                    int rows = cmd.ExecuteNonQuery();

                    if (rows > 0)
                    {
                        lblAlert.Text = "✓ Message #" + messageId + " deleted successfully.";
                        pnlAlert.Visible = true;
                    }
                    else
                    {
                        lblAlert.Text = "⚠ Message not found or already deleted.";
                        pnlAlert.Visible = true;
                    }
                }

                // Reload the list to reflect changes
                LoadMessages();
            }
            catch (Exception ex)
            {
                lblAlert.Text = "⚠ Error deleting message: " + ex.Message;
                pnlAlert.Visible = true;
            }
        }

        // ============================================
        // CONFIRM DELETE BUTTON (from modal)
        // ============================================
        protected void btnConfirmDelete_Click(object sender, EventArgs e)
        {
            try
            {
                string raw = hfDeleteID.Value;

                if (string.IsNullOrWhiteSpace(raw))
                {
                    lblAlert.Text = "⚠ No message selected for deletion.";
                    pnlAlert.Visible = true;
                    return;
                }

                // Format: "uniqueId|messageId"
                string[] parts = raw.Split('|');
                int messageId = 0;

                if (parts.Length >= 2)
                {
                    int.TryParse(parts[1], out messageId);
                }

                if (messageId <= 0)
                {
                    lblAlert.Text = "⚠ Invalid message ID.";
                    pnlAlert.Visible = true;
                    return;
                }

                DeleteMessage(messageId);
                hfDeleteID.Value = "";
            }
            catch (Exception ex)
            {
                lblAlert.Text = "⚠ Error: " + ex.Message;
                pnlAlert.Visible = true;
            }
        }

        // ============================================
        // LOAD SINGLE MESSAGE INTO MODAL
        // ============================================
        private void LoadMessageIntoModal(int messageId)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    string query = @"
                        SELECT [MessageID], [Name], [Email], [Mobile], [Subject], 
                               [Message], [Status], [AdminResponse], [ReceivedDate]
                        FROM [StudySwap].[dbo].[ContactMessages]
                        WHERE [MessageID] = @ID";

                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@ID", messageId);

                    con.Open();
                    SqlDataReader dr = cmd.ExecuteReader();

                    if (dr.Read())
                    {
                        hfMessageID.Value = dr["MessageID"].ToString();

                        string name = JsEncode(dr["Name"]);
                        string email = JsEncode(dr["Email"]);
                        string subject = JsEncode(dr["Subject"]);

                        string mobileRaw = dr["Mobile"] == DBNull.Value
                            ? ""
                            : dr["Mobile"].ToString().Trim();

                        string mobileDisplay = string.IsNullOrEmpty(mobileRaw) ? "—" : mobileRaw;

                        string mobileHtml;
                        if (string.IsNullOrEmpty(mobileRaw))
                        {
                            mobileHtml = "<span style='color:#94a3b8;font-style:italic;'>—</span>";
                        }
                        else
                        {
                            string telHref = HttpUtility.HtmlAttributeEncode(
                                mobileRaw.Replace(" ", "").Replace("-", ""));
                            string mobileDisplayEnc = HttpUtility.HtmlEncode(mobileRaw);
                            mobileHtml = "<a href='tel:" + telHref + "'>" + mobileDisplayEnc + "</a>";
                        }

                        string message = dr["Message"].ToString()
                                            .Replace("\\", "\\\\")
                                            .Replace("'", "\\'")
                                            .Replace("\r", "")
                                            .Replace("\n", "\\n");

                        string date = Convert.ToDateTime(dr["ReceivedDate"])
                                            .ToString("dd MMM yyyy, hh:mm tt");

                        string existingResponse = "";
                        if (dr["AdminResponse"] != DBNull.Value)
                            existingResponse = dr["AdminResponse"].ToString();

                        txtResponse.Text = existingResponse;

                        string script = @"
                            document.getElementById('mName').innerText = '" + name + @"';
                            document.getElementById('mEmail').innerText = '" + email + @"';
                            document.getElementById('mMobile').innerHTML = """ + mobileHtml.Replace("\"", "\\\"") + @""";
                            document.getElementById('mSubject').innerText = '" + subject + @"';
                            document.getElementById('mMessage').innerText = '" + message + @"';
                            document.getElementById('mDate').innerText = '" + date + @"';
                            openModal();";

                        ScriptManager.RegisterStartupScript(this, GetType(),
                            "OpenModal_" + messageId, script, true);
                    }
                    dr.Close();
                }
            }
            catch (Exception ex)
            {
                lblAlert.Text = "⚠ Error loading message: " + ex.Message;
                pnlAlert.Visible = true;
            }
        }

        // ============================================
        // SEND RESPONSE
        // ============================================
        protected void btnSendResponse_Click(object sender, EventArgs e)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(hfMessageID.Value))
                {
                    lblAlert.Text = "⚠ No message selected.";
                    pnlAlert.Visible = true;
                    return;
                }

                if (string.IsNullOrWhiteSpace(txtResponse.Text))
                {
                    lblAlert.Text = "⚠ Please type a response before sending.";
                    pnlAlert.Visible = true;

                    ScriptManager.RegisterStartupScript(this, GetType(),
                        "ReopenModal", "openModal();", true);
                    return;
                }

                int messageId = Convert.ToInt32(hfMessageID.Value);
                string adminName = Session["AdminName"] != null
                                    ? Session["AdminName"].ToString()
                                    : "Admin";

                using (SqlConnection con = new SqlConnection(cs))
                {
                    string query = @"
                        UPDATE [StudySwap].[dbo].[ContactMessages]
                        SET [AdminResponse] = @Response,
                            [Status] = 'Responded',
                            [RespondedBy] = @RespondedBy,
                            [ResponseDate] = GETDATE()
                        WHERE [MessageID] = @ID";

                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@Response", txtResponse.Text.Trim());
                    cmd.Parameters.AddWithValue("@RespondedBy", adminName);
                    cmd.Parameters.AddWithValue("@ID", messageId);

                    con.Open();
                    int rows = cmd.ExecuteNonQuery();

                    if (rows > 0)
                    {
                        lblAlert.Text = "✓ Response sent successfully to message #" + messageId;
                        pnlAlert.Visible = true;
                        txtResponse.Text = "";
                        hfMessageID.Value = "";

                        LoadMessages();
                    }
                    else
                    {
                        lblAlert.Text = "⚠ Message not found.";
                        pnlAlert.Visible = true;
                    }
                }
            }
            catch (Exception ex)
            {
                lblAlert.Text = "⚠ Error sending response: " + ex.Message;
                pnlAlert.Visible = true;
            }
        }

        // ============================================
        // HELPER: Truncate long text
        // ============================================
        public string Truncate(object text, int maxLength)
        {
            if (text == null || text == DBNull.Value) return "";
            string s = text.ToString();
            if (s.Length <= maxLength) return s;
            return s.Substring(0, maxLength) + "...";
        }

        // ============================================
        // HELPER: Format Mobile as click-to-call link
        // ============================================
        public string FormatMobile(object mobile)
        {
            if (mobile == null || mobile == DBNull.Value)
                return "<span class='no-mobile'>—</span>";

            string raw = mobile.ToString().Trim();
            if (string.IsNullOrEmpty(raw))
                return "<span class='no-mobile'>—</span>";

            string telHref = raw.Replace(" ", "").Replace("-", "");
            string displayEnc = HttpUtility.HtmlEncode(raw);
            string hrefEnc = HttpUtility.HtmlAttributeEncode(telHref);

            return "<a href=\"tel:" + hrefEnc + "\" title=\"Click to call\">" + displayEnc + "</a>";
        }

        // ============================================
        // HELPER: Status Badge HTML
        // ============================================
        public string GetStatusBadge(object status)
        {
            string s = (status == null || status == DBNull.Value)
                        ? "Pending"
                        : status.ToString();

            if (s.Equals("Responded", StringComparison.OrdinalIgnoreCase))
                return "<span class='badge badge-responded'>Responded</span>";
            else if (s.Equals("Read", StringComparison.OrdinalIgnoreCase))
                return "<span class='badge badge-read'>Read</span>";
            else
                return "<span class='badge badge-pending'>Pending</span>";
        }

        // ============================================
        // HELPER: Safe JS string escaping
        // ============================================
        private string JsEncode(object value)
        {
            if (value == null || value == DBNull.Value) return "";
            return value.ToString()
                        .Replace("\\", "\\\\")
                        .Replace("'", "\\'")
                        .Replace("\r", "")
                        .Replace("\n", "\\n");
        }
    }
}