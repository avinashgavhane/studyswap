using System;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Security.Cryptography;
using System.Text;

namespace StudySwap.Student
{
    public partial class EditProfile : System.Web.UI.Page
    {
        private string connStr = ConfigurationManager.ConnectionStrings["LIS"].ConnectionString;

        protected int UserID
        {
            get
            {
                if (Session["UserID"] != null)
                    return Convert.ToInt32(Session["UserID"]);

                if (int.TryParse(Request.QueryString["UserID"], out int sid))
                    return sid;

                return 0;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (UserID == 0)
                {
                    Response.Redirect("~/Login.aspx");
                    return;
                }

                LoadDropdowns();
                LoadStudentData();
            }
        }

        private void LoadDropdowns()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();

                SqlCommand cmdColleges = new SqlCommand("SELECT CollegeID, CollegeName FROM Colleges", con);
                ddlCollege.DataSource = cmdColleges.ExecuteReader();
                ddlCollege.DataValueField = "CollegeID";
                ddlCollege.DataTextField = "CollegeName";
                ddlCollege.DataBind();
                ddlCollege.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- Select College --", "0"));

                con.Close();
                con.Open();

                SqlCommand cmdDepartments = new SqlCommand("SELECT DepartmentID, DepartmentName FROM Departments", con);
                ddlDepartment.DataSource = cmdDepartments.ExecuteReader();
                ddlDepartment.DataValueField = "DepartmentID";
                ddlDepartment.DataTextField = "DepartmentName";
                ddlDepartment.DataBind();
                ddlDepartment.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- Select Department --", "0"));
            }

            ddlYear.Items.Clear();
            ddlYear.Items.Add(new System.Web.UI.WebControls.ListItem("-- Select Year --", "0"));
            ddlYear.Items.Add(new System.Web.UI.WebControls.ListItem("1st Year", "1"));
            ddlYear.Items.Add(new System.Web.UI.WebControls.ListItem("2nd Year", "2"));
            ddlYear.Items.Add(new System.Web.UI.WebControls.ListItem("3rd Year", "3"));
            ddlYear.Items.Add(new System.Web.UI.WebControls.ListItem("4th Year", "4"));
        }

        protected void LoadStudentData()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT FullName, Email, Phone, College, Department, YearOfStudy, RollNumber, ProfilePicture, StudentIDProofPath, ShowPhoneToVerified
                    FROM Users WHERE UserID = @UserID";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@UserID", UserID);
                con.Open();

                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    txtFullName.Text = dr["FullName"].ToString();
                    txtEmail.Text = dr["Email"].ToString();
                    txtPhone.Text = dr["Phone"].ToString();
                    txtRoll.Text = dr["RollNumber"].ToString();
                    chkAllowWhatsApp.Checked = dr["ShowPhoneToVerified"] != DBNull.Value && Convert.ToBoolean(dr["ShowPhoneToVerified"]);

                    ddlCollege.SelectedValue = dr["College"]?.ToString() ?? "0";
                    ddlDepartment.SelectedValue = dr["Department"]?.ToString() ?? "0";
                    ddlYear.SelectedValue = dr["YearOfStudy"]?.ToString() ?? "0";

                    if (dr["ProfilePicture"] != DBNull.Value && !string.IsNullOrEmpty(dr["ProfilePicture"].ToString()))
                    {
                        imgHeaderProfile.ImageUrl = dr["ProfilePicture"].ToString();
                        imgProfile.ImageUrl = dr["ProfilePicture"].ToString();
                        imgProfile.Visible = true;
                    }
                    else
                    {
                        imgProfile.Visible = false;
                    }

                    if (dr["StudentIDProofPath"] != DBNull.Value && !string.IsNullOrEmpty(dr["StudentIDProofPath"].ToString()))
                    {
                        imgIDProof.ImageUrl = dr["StudentIDProofPath"].ToString();
                        imgIDProof.Visible = true;
                    }
                    else
                    {
                        imgIDProof.Visible = false;
                    }
                }
                dr.Close();
            }
        }

        // ================= NEW: CHANGE PASSWORD =================
        protected void btnChangePassword_Click(object sender, EventArgs e)
        {
            if (UserID == 0)
            {
                SetPwdStatus("Invalid session. Please login again.", false);
                return;
            }

            string currentPlain = txtCurrentPwd.Text.Trim();
            string newPlain = txtNewPwd.Text.Trim();
            string confirmPlain = txtConfirmPwd.Text.Trim();

            if (string.IsNullOrEmpty(currentPlain) || string.IsNullOrEmpty(newPlain) || string.IsNullOrEmpty(confirmPlain))
            {
                SetPwdStatus("All password fields are required.", false);
                return;
            }

            if (newPlain.Length < 8)
            {
                SetPwdStatus("New password must be at least 8 characters.", false);
                return;
            }

            if (!string.Equals(newPlain, confirmPlain, StringComparison.Ordinal))
            {
                SetPwdStatus("New password and confirm password do not match.", false);
                return;
            }

            string currentHash = HashPassword(currentPlain);
            string newHash = HashPassword(newPlain);

            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();

                    // 1. Get current stored hash
                    string storedHash = null;
                    using (SqlCommand cmd = new SqlCommand(
                        "SELECT PasswordHash FROM Users WHERE UserID = @UserID", con))
                    {
                        cmd.Parameters.AddWithValue("@UserID", UserID);
                        object o = cmd.ExecuteScalar();
                        if (o == null || o == DBNull.Value)
                        {
                            SetPwdStatus("Account not found.", false);
                            return;
                        }
                        storedHash = o.ToString();
                    }

                    // 2. Verify current password
                    if (!string.Equals(storedHash, currentHash, StringComparison.OrdinalIgnoreCase))
                    {
                        SetPwdStatus("Current password is incorrect.", false);
                        return;
                    }

                    // 3. Prevent same as old
                    if (string.Equals(storedHash, newHash, StringComparison.OrdinalIgnoreCase))
                    {
                        SetPwdStatus("New password must be different from current password.", false);
                        return;
                    }

                    // 4. Update
                    using (SqlCommand cmd = new SqlCommand(
                        "UPDATE Users SET PasswordHash = @Hash, LastModified = GETDATE() WHERE UserID = @UserID", con))
                    {
                        cmd.Parameters.AddWithValue("@Hash", newHash);
                        cmd.Parameters.AddWithValue("@UserID", UserID);
                        int rows = cmd.ExecuteNonQuery();

                        if (rows > 0)
                        {
                            SetPwdStatus("Password updated successfully.", true);
                            txtCurrentPwd.Text = "";
                            txtNewPwd.Text = "";
                            txtConfirmPwd.Text = "";
                        }
                        else
                        {
                            SetPwdStatus("Password update failed. Please try again.", false);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                SetPwdStatus("Error: " + ex.Message, false);
            }
        }

        private void SetPwdStatus(string message, bool ok)
        {
            lblPwdStatus.Visible = true;
            lblPwdStatus.Text = message;
            lblPwdStatus.CssClass = "pwd-msg " + (ok ? "ok" : "err");
        }

        // SHA-256 hex — matches your existing PasswordHash format
        private string HashPassword(string plain)
        {
            using (var sha = SHA256.Create())
            {
                byte[] bytes = sha.ComputeHash(Encoding.UTF8.GetBytes(plain));
                var sb = new StringBuilder();
                foreach (byte b in bytes) sb.Append(b.ToString("x2"));
                return sb.ToString();
            }
        }
        // =======================================================

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (UserID == 0)
            {
                lblStatus.Text = "Invalid Student ID.";
                lblStatus.CssClass = "text-danger";
                lblStatus.Visible = true;
                return;
            }

            string profilePath = null;
            string idProofPath = null;

            // Upload Profile Picture
            if (fuProfile.HasFile)
            {
                try
                {
                    string profileFolder = Server.MapPath("~/Uploads/StudentPhoto/");
                    if (!Directory.Exists(profileFolder))
                    {
                        Directory.CreateDirectory(profileFolder);
                        lblStatus.Text = $"Profile photo folder created: {profileFolder}";
                        lblStatus.CssClass = "text-success";
                        lblStatus.Visible = true;
                    }

                    DeleteOldFile(UserID, profileFolder, "student_");

                    string ext = Path.GetExtension(fuProfile.FileName);
                    string fileName = $"student_{UserID}{ext}";
                    string savePath = Path.Combine(profileFolder, fileName);

                    fuProfile.SaveAs(savePath);
                    profilePath = "~/Uploads/StudentPhoto/" + fileName;
                }
                catch (Exception ex)
                {
                    lblStatus.Text = "Error uploading profile photo: " + ex.Message;
                    lblStatus.CssClass = "text-danger";
                    lblStatus.Visible = true;
                    return;
                }
            }

            // Upload ID Proof
            if (fuIDProof.HasFile)
            {
                try
                {
                    string idProofFolder = Server.MapPath("~/Uploads/StudentIDProof/");
                    if (!Directory.Exists(idProofFolder))
                    {
                        Directory.CreateDirectory(idProofFolder);
                        lblStatus.Text = $"ID proof folder created: {idProofFolder}";
                        lblStatus.CssClass = "text-success";
                        lblStatus.Visible = true;
                    }

                    DeleteOldFile(UserID, idProofFolder, "idproof_");

                    string ext = Path.GetExtension(fuIDProof.FileName);
                    string year = ddlYear.SelectedValue != "0" ? ddlYear.SelectedValue : "NA";
                    string fileName = $"idproof_{UserID}_{year}{ext}";
                    string savePath = Path.Combine(idProofFolder, fileName);

                    fuIDProof.SaveAs(savePath);
                    idProofPath = "~/Uploads/StudentIDProof/" + fileName;
                }
                catch (Exception ex)
                {
                    lblStatus.Text = "Error uploading ID proof: " + ex.Message;
                    lblStatus.CssClass = "text-danger";
                    lblStatus.Visible = true;
                    return;
                }
            }

            // Update database
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    string query = @"
                        UPDATE Users SET
                            FullName = @FullName,
                            Phone = @Phone,
                            College = @College,
                            Department = @Department,
                            YearOfStudy = @YearOfStudy,
                            RollNumber = @RollNumber";

                    if (profilePath != null)
                        query += ", ProfilePicture = @ProfilePicture";

                    if (idProofPath != null)
                        query += ", StudentIDProofPath = @StudentIDProofPath";

                    query += " WHERE UserID = @UserID";

                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@FullName", txtFullName.Text.Trim());
                    cmd.Parameters.AddWithValue("@Phone", txtPhone.Text.Trim());
                    cmd.Parameters.AddWithValue("@College", ddlCollege.SelectedValue);
                    cmd.Parameters.AddWithValue("@Department", ddlDepartment.SelectedValue);
                    cmd.Parameters.AddWithValue("@YearOfStudy", ddlYear.SelectedValue);
                    cmd.Parameters.AddWithValue("@RollNumber", txtRoll.Text.Trim());
                    cmd.Parameters.AddWithValue("@ShowPhoneToVerified", chkAllowWhatsApp.Checked);

                    if (profilePath != null)
                        cmd.Parameters.AddWithValue("@ProfilePicture", profilePath);

                    if (idProofPath != null)
                        cmd.Parameters.AddWithValue("@StudentIDProofPath", idProofPath);

                    cmd.Parameters.AddWithValue("@UserID", UserID);

                    con.Open();
                    int rows = cmd.ExecuteNonQuery();

                    if (rows > 0)
                    {
                        lblStatus.Text = "Profile updated successfully!";
                        lblStatus.CssClass = "text-success";
                        lblStatus.Visible = true;

                        LoadStudentData();
                    }
                    else
                    {
                        lblStatus.Text = "Update failed. Please try again.";
                        lblStatus.CssClass = "text-danger";
                        lblStatus.Visible = true;
                    }
                }
            }
            catch (Exception ex)
            {
                lblStatus.Text = "Database update error: " + ex.Message;
                lblStatus.CssClass = "text-danger";
                lblStatus.Visible = true;
            }
        }

        private void DeleteOldFile(int userId, string folderPath, string filePrefix)
        {
            try
            {
                var files = Directory.GetFiles(folderPath, $"{filePrefix}{userId}*");
                foreach (var file in files)
                {
                    File.Delete(file);
                }
            }
            catch (Exception)
            {
                // log if needed
            }
        }
    }
}
