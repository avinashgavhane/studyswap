using System;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Security.Cryptography;
using System.Text;
using System.Web.UI.WebControls;

namespace StudySwap
{

    public partial class Register : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["LIS"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                pnlSuccess.Visible = false;
                LoadColleges();
            }
        }

        // Load college dropdown (static for now)


        protected void btnRegister_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            if (!chkTerms.Checked)
            {
                ValidationSummary1.HeaderText = "You must accept the Terms & Conditions.";
                return;
            }

            if (!fuStudentID.HasFile) return;

            // Check duplicate email or roll number
            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlCommand checkCmd = new SqlCommand(
                    "SELECT COUNT(*) FROM Users WHERE Email=@Email OR RollNumber=@RollNumber", con);

                checkCmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
                checkCmd.Parameters.AddWithValue("@RollNumber", txtRollNumber.Text.Trim());

                con.Open();
                int exists = (int)checkCmd.ExecuteScalar();

                if (exists > 0)
                {
                    ValidationSummary1.HeaderText = "Email or Roll Number already registered.";
                    return;
                }
            }

            // Validate file
            string fileExt = Path.GetExtension(fuStudentID.FileName).ToLower();
            string[] allowedExt = { ".jpg", ".jpeg", ".png", ".pdf" };

            if (Array.IndexOf(allowedExt, fileExt) < 0) return;
            if (fuStudentID.PostedFile.ContentLength > 5 * 1024 * 1024) return;

            int newUserId;

            // 1️⃣ INSERT USER FIRST
            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(@"
INSERT INTO Users
(
    FullName, Email, PasswordHash, Phone,
    College, Department, CourseID,
    YearOfStudy, RollNumber,
    IsVerified, UserRole,
    AccountStatus, MemberSince, LastModified
)
VALUES
(
    @FullName, @Email, @PasswordHash, @Phone,
    @College, @Department, @CourseID,
    @YearOfStudy, @RollNumber,
    0, 'Student',
    'Active', GETDATE(), GETDATE()
);
SELECT SCOPE_IDENTITY();", con);

                cmd.Parameters.AddWithValue("@FullName", txtFullName.Text.Trim());
                cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
                cmd.Parameters.AddWithValue("@PasswordHash", HashPassword(txtPassword.Text.Trim()));
                cmd.Parameters.AddWithValue("@Phone", txtPhone.Text.Trim());
                cmd.Parameters.AddWithValue("@College", ddlCollege.SelectedValue);
                cmd.Parameters.AddWithValue("@Department", ddlDepartment.SelectedValue);
                cmd.Parameters.AddWithValue("@CourseID", ddlCourse.SelectedValue);
                cmd.Parameters.AddWithValue("@YearOfStudy", ddlYear.SelectedValue);
                cmd.Parameters.AddWithValue("@RollNumber", txtRollNumber.Text.Trim());

                con.Open();
                newUserId = Convert.ToInt32(cmd.ExecuteScalar());
            }

            // 2️⃣ SAVE FILE USING USERID
            string folderPath = Server.MapPath("~/Uploads/StudentID/");
            if (!Directory.Exists(folderPath))
                Directory.CreateDirectory(folderPath);

            string fileName = "StudentID_" + newUserId + fileExt;
            string filePath = Path.Combine(folderPath, fileName);
            fuStudentID.SaveAs(filePath);

            // 3️⃣ UPDATE PHOTO PATH
            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(
                    "UPDATE Users SET StudentIDProofPath=@Path WHERE UserID=@UserID", con);

                cmd.Parameters.AddWithValue("@Path", "~/Uploads/StudentID/" + fileName);
                cmd.Parameters.AddWithValue("@UserID", newUserId);

                con.Open();
                cmd.ExecuteNonQuery();
            }

            pnlSuccess.Visible = true;
            ClearForm();
        }

        private void ClearForm()
        {
            txtFullName.Text = "";
            txtEmail.Text = "";
            txtPhone.Text = "";
            txtPassword.Text = "";
            txtConfirmPassword.Text = "";
            ddlCollege.SelectedIndex = 0;
            ddlDepartment.SelectedIndex = 0;
            ddlYear.SelectedIndex = 0;
            txtRollNumber.Text = "";
            chkTerms.Checked = false;
        }

        // Secure SHA256 hashing
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
        void LoadColleges()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(
                    "SELECT CollegeID, CollegeName FROM Colleges WHERE IsActive = 1", con);

                con.Open();
                ddlCollege.DataSource = cmd.ExecuteReader();
                ddlCollege.DataTextField = "CollegeName";
                ddlCollege.DataValueField = "CollegeID";
                ddlCollege.DataBind();
            }

            ddlCollege.Items.Insert(0, new ListItem("-- Select College --", ""));
        }

        protected void ddlCollege_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlDepartment.Items.Clear();
            ddlCourse.Items.Clear();

            if (ddlCollege.SelectedValue != "")
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand(
                        "SELECT DepartmentID, DepartmentName FROM Departments WHERE CollegeID=@CollegeID AND IsActive=1", con);

                    cmd.Parameters.AddWithValue("@CollegeID", ddlCollege.SelectedValue);

                    con.Open();
                    ddlDepartment.DataSource = cmd.ExecuteReader();
                    ddlDepartment.DataTextField = "DepartmentName";
                    ddlDepartment.DataValueField = "DepartmentID";
                    ddlDepartment.DataBind();
                }
            }

            ddlDepartment.Items.Insert(0, new ListItem("-- Select Department --", ""));
            ddlCourse.Items.Insert(0, new ListItem("-- Select Course --", ""));
        }

        protected void ddlDepartment_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlCourse.Items.Clear();

            if (!string.IsNullOrEmpty(ddlDepartment.SelectedValue))
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand(
                        "SELECT CourseID, CourseName FROM Courses WHERE DepartmentID=@DepartmentID AND IsActive=1", con);

                    cmd.Parameters.AddWithValue("@DepartmentID", ddlDepartment.SelectedValue);

                    con.Open();
                    ddlCourse.DataSource = cmd.ExecuteReader();
                    ddlCourse.DataTextField = "CourseName";
                    ddlCourse.DataValueField = "CourseID";
                    ddlCourse.DataBind();
                }
            }

            ddlCourse.Items.Insert(0, new ListItem("-- Select Course --", ""));
        }

        protected void ddlCourse_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
    }
}
