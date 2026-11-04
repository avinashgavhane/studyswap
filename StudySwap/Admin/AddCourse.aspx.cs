using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace StudySwap.Admin
{
    public partial class AddCourse : System.Web.UI.Page
    {
        private string ConnStr =>
            ConfigurationManager.ConnectionStrings["LIS"].ConnectionString;

        private int EditingCourseID
        {
            get { return ViewState["EditingCourseID"] == null ? 0 : (int)ViewState["EditingCourseID"]; }
            set { ViewState["EditingCourseID"] = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindDepartments();
                BindCourses();
                SetAddMode();
            }
        }

        #region Mode helpers

        private void SetAddMode()
        {
            EditingCourseID = 0;
            hfCourseID.Value = "0";
            litFormTitle.Text = "Add New Course";
            btnSave.Text = "Save Course";
            btnCancel.Visible = false;
            ClearFields();
        }

        private void SetEditMode(int courseId)
        {
            EditingCourseID = courseId;
            hfCourseID.Value = courseId.ToString();
            litFormTitle.Text = "Edit Course #" + courseId;
            btnSave.Text = "Update Course";
            btnCancel.Visible = true;
        }

        #endregion

        #region Bind dropdown + grid

        private void BindDepartments()
        {
            using (SqlConnection con = new SqlConnection(ConnStr))
            {
                // Assumes Departments table has DepartmentID + DepartmentName
                string query = @"SELECT [DepartmentID],[DepartmentName]
                                 FROM [StudySwap].[dbo].[Departments]
                                 WHERE [IsActive] = 1
                                 ORDER BY [DepartmentName]";

                using (SqlDataAdapter da = new SqlDataAdapter(query, con))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    ddlDepartment.DataSource = dt;
                    ddlDepartment.DataTextField = "DepartmentName";
                    ddlDepartment.DataValueField = "DepartmentID";
                    ddlDepartment.DataBind();

                    ddlDepartment.Items.Insert(0, new ListItem("-- Select Department --", "0"));
                }
            }
        }

        private void BindCourses()
        {
            using (SqlConnection con = new SqlConnection(ConnStr))
            {
                // JOIN with Departments so the grid shows the department name
                string query = @"SELECT TOP (1000) 
                                       c.[CourseID],
                                       c.[DepartmentID],
                                       d.[DepartmentName],
                                       c.[CourseName],
                                       c.[CourseCode],
                                       c.[Semester],
                                       c.[IsActive]
                                 FROM [StudySwap].[dbo].[Courses] c
                                 LEFT JOIN [StudySwap].[dbo].[Departments] d 
                                        ON c.[DepartmentID] = d.[DepartmentID]
                                 ORDER BY c.[CourseID] DESC";

                using (SqlDataAdapter da = new SqlDataAdapter(query, con))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    gvCourses.DataSource = dt;
                    gvCourses.DataBind();
                }
            }
        }

        private void LoadCourseIntoForm(int courseId)
        {
            using (SqlConnection con = new SqlConnection(ConnStr))
            {
                string query = @"SELECT [CourseID],[DepartmentID],[CourseName],[CourseCode],[Semester],[IsActive]
                                 FROM [StudySwap].[dbo].[Courses]
                                 WHERE [CourseID] = @CourseID";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@CourseID", courseId);
                    con.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            string deptId = dr["DepartmentID"].ToString();
                            if (ddlDepartment.Items.FindByValue(deptId) != null)
                                ddlDepartment.SelectedValue = deptId;

                            txtCourseName.Text = dr["CourseName"] as string ?? "";
                            txtCourseCode.Text = dr["CourseCode"] as string ?? "";
                            txtSemester.Text = dr["Semester"] as string ?? "";
                            chkIsActive.Checked = dr["IsActive"] != DBNull.Value && Convert.ToBoolean(dr["IsActive"]);
                        }
                    }
                }
            }
        }

        #endregion

        #region Save / Update

        protected void btnSave_Click(object sender, EventArgs e)
        {
            // Validation
            if (ddlDepartment.SelectedValue == "0")
            {
                lblMsg.ForeColor = System.Drawing.Color.Red;
                lblMsg.Text = "Please select a department.";
                return;
            }
            if (string.IsNullOrWhiteSpace(txtCourseName.Text))
            {
                lblMsg.ForeColor = System.Drawing.Color.Red;
                lblMsg.Text = "Course Name is required.";
                return;
            }

            try
            {
                if (EditingCourseID > 0)
                    UpdateCourse(EditingCourseID);
                else
                    InsertCourse();

                BindCourses();
                SetAddMode();

                lblMsg.ForeColor = System.Drawing.Color.Green;
                lblMsg.Text = "Saved successfully!";
            }
            catch (Exception ex)
            {
                lblMsg.ForeColor = System.Drawing.Color.Red;
                lblMsg.Text = "Error: " + ex.Message;
            }
        }

        private void InsertCourse()
        {
            using (SqlConnection con = new SqlConnection(ConnStr))
            {
                string query = @"INSERT INTO [StudySwap].[dbo].[Courses]
                                    ([DepartmentID],[CourseName],[CourseCode],[Semester],[IsActive])
                                 VALUES
                                    (@DepartmentID,@CourseName,@CourseCode,@Semester,@IsActive)";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@DepartmentID", Convert.ToInt32(ddlDepartment.SelectedValue));
                    cmd.Parameters.AddWithValue("@CourseName", txtCourseName.Text.Trim());
                    cmd.Parameters.AddWithValue("@CourseCode", (object)txtCourseCode.Text.Trim() ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@Semester", (object)txtSemester.Text.Trim() ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@IsActive", chkIsActive.Checked);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        private void UpdateCourse(int courseId)
        {
            using (SqlConnection con = new SqlConnection(ConnStr))
            {
                string query = @"UPDATE [StudySwap].[dbo].[Courses]
                                    SET [DepartmentID] = @DepartmentID,
                                        [CourseName]   = @CourseName,
                                        [CourseCode]   = @CourseCode,
                                        [Semester]     = @Semester,
                                        [IsActive]     = @IsActive
                                  WHERE [CourseID]     = @CourseID";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@DepartmentID", Convert.ToInt32(ddlDepartment.SelectedValue));
                    cmd.Parameters.AddWithValue("@CourseName", txtCourseName.Text.Trim());
                    cmd.Parameters.AddWithValue("@CourseCode", (object)txtCourseCode.Text.Trim() ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@Semester", (object)txtSemester.Text.Trim() ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@IsActive", chkIsActive.Checked);
                    cmd.Parameters.AddWithValue("@CourseID", courseId);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        #endregion

        #region Cancel / Clear

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            SetAddMode();
            lblMsg.Text = string.Empty;
        }

        private void ClearFields()
        {
            if (ddlDepartment.Items.Count > 0)
                ddlDepartment.SelectedIndex = 0;

            txtCourseName.Text = string.Empty;
            txtCourseCode.Text = string.Empty;
            txtSemester.Text = string.Empty;
            chkIsActive.Checked = true;
        }

        #endregion

        #region GridView events

        protected void gvCourses_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvCourses.PageIndex = e.NewPageIndex;
            BindCourses();
        }

        protected void gvCourses_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditCourse")
            {
                int courseId = Convert.ToInt32(e.CommandArgument);
                LoadCourseIntoForm(courseId);
                SetEditMode(courseId);

                lblMsg.ForeColor = System.Drawing.Color.DarkOrange;
                lblMsg.Text = "Editing Course #" + courseId + ". Change and click Update.";
            }
        }

        protected void gvCourses_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int courseId = Convert.ToInt32(gvCourses.DataKeys[e.RowIndex].Value);

            try
            {
                using (SqlConnection con = new SqlConnection(ConnStr))
                {
                    string query = "DELETE FROM [StudySwap].[dbo].[Courses] WHERE [CourseID] = @CourseID";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@CourseID", courseId);
                        con.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                if (EditingCourseID == courseId)
                    SetAddMode();

                BindCourses();
                lblMsg.ForeColor = System.Drawing.Color.Green;
                lblMsg.Text = "Course deleted successfully.";
            }
            catch (Exception ex)
            {
                lblMsg.ForeColor = System.Drawing.Color.Red;
                lblMsg.Text = "Delete failed: " + ex.Message;
            }
        }

        #endregion
    }
}