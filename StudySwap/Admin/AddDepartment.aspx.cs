using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace StudySwap.Admin
{
    public partial class AddDepartment : System.Web.UI.Page
    {
        // Read connection string from Web.config (recommended)
        // Add: <connectionStrings><add name="StudySwapDB" connectionString="Data Source=.;Initial Catalog=StudySwap;Integrated Security=True" providerName="System.Data.SqlClient"/></connectionStrings>
        private string ConnStr
        {
            get
            {
                // Fallback connection string if not in config
                var cs = ConfigurationManager.ConnectionStrings["LIS"];
                if (cs != null && !string.IsNullOrEmpty(cs.ConnectionString))
                    return cs.ConnectionString;

                return @"Data Source=.;Initial Catalog=StudySwap;Integrated Security=True";
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadColleges();
                BindGrid();
            }
        }

        #region Load Dropdowns

        private void LoadColleges()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConnStr))
                {
                    string query = @"SELECT CollegeID, CollegeName 
                                     FROM Colleges 
                                     WHERE IsActive = 1 
                                     ORDER BY CollegeName";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        con.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            ddlCollege.DataSource = reader;
                            ddlCollege.DataTextField = "CollegeName";
                            ddlCollege.DataValueField = "CollegeID";
                            ddlCollege.DataBind();
                        }
                    }
                }

                // Insert default "Select College" item
                ddlCollege.Items.Insert(0, new ListItem("-- Select College --", "0"));
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading colleges: " + ex.Message, false);
            }
        }

        #endregion

        #region Bind Grid

        private void BindGrid(string searchTerm = "")
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConnStr))
                {
                    string query = @"
                        SELECT 
                            d.DepartmentID,
                            d.CollegeID,
                            d.DepartmentName,
                            d.DepartmentCode,
                            d.IsActive,
                            c.CollegeName
                        FROM Departments d
                        INNER JOIN Colleges c ON d.CollegeID = c.CollegeID
                        WHERE (@Search = '' 
                               OR d.DepartmentName LIKE '%' + @Search + '%'
                               OR d.DepartmentCode LIKE '%' + @Search + '%')
                        ORDER BY c.CollegeName, d.DepartmentName";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@Search", searchTerm ?? string.Empty);

                        using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            da.Fill(dt);

                            gvDepartments.DataSource = dt;
                            gvDepartments.DataBind();

                            litRecordCount.Text = dt.Rows.Count.ToString();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading departments: " + ex.Message, false);
            }
        }

        #endregion

        #region Save (Add / Update)

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            int departmentId = 0;
            int.TryParse(hfDepartmentID.Value, out departmentId);

            int collegeId = 0;
            int.TryParse(ddlCollege.SelectedValue, out collegeId);

            string deptName = txtDepartmentName.Text.Trim();
            string deptCode = txtDepartmentCode.Text.Trim();
            bool isActive = chkIsActive.Checked;

            // Basic validation
            if (collegeId <= 0)
            {
                ShowMessage("Please select a valid college.", false);
                return;
            }
            if (string.IsNullOrWhiteSpace(deptName))
            {
                ShowMessage("Department name is required.", false);
                return;
            }

            try
            {
                using (SqlConnection con = new SqlConnection(ConnStr))
                {
                    con.Open();

                    // Check for duplicate department name within same college (exclude current record in edit mode)
                    string dupCheck = @"
                        SELECT COUNT(*) FROM Departments 
                        WHERE CollegeID = @CollegeID 
                          AND DepartmentName = @DepartmentName 
                          AND DepartmentID <> @DepartmentID";

                    using (SqlCommand cmdCheck = new SqlCommand(dupCheck, con))
                    {
                        cmdCheck.Parameters.AddWithValue("@CollegeID", collegeId);
                        cmdCheck.Parameters.AddWithValue("@DepartmentName", deptName);
                        cmdCheck.Parameters.AddWithValue("@DepartmentID", departmentId);

                        int count = Convert.ToInt32(cmdCheck.ExecuteScalar());
                        if (count > 0)
                        {
                            ShowMessage("A department with this name already exists in the selected college.", false);
                            return;
                        }
                    }

                    if (departmentId > 0)
                    {
                        // UPDATE
                        string updateQuery = @"
                            UPDATE Departments 
                            SET CollegeID = @CollegeID,
                                DepartmentName = @DepartmentName,
                                DepartmentCode = @DepartmentCode,
                                IsActive = @IsActive
                            WHERE DepartmentID = @DepartmentID";

                        using (SqlCommand cmd = new SqlCommand(updateQuery, con))
                        {
                            cmd.Parameters.AddWithValue("@CollegeID", collegeId);
                            cmd.Parameters.AddWithValue("@DepartmentName", deptName);
                            cmd.Parameters.AddWithValue("@DepartmentCode", string.IsNullOrEmpty(deptCode) ? (object)DBNull.Value : deptCode);
                            cmd.Parameters.AddWithValue("@IsActive", isActive);
                            cmd.Parameters.AddWithValue("@DepartmentID", departmentId);

                            cmd.ExecuteNonQuery();
                        }

                        ShowMessage("Department updated successfully.", true);
                    }
                    else
                    {
                        // INSERT
                        string insertQuery = @"
                            INSERT INTO Departments (CollegeID, DepartmentName, DepartmentCode, IsActive)
                            VALUES (@CollegeID, @DepartmentName, @DepartmentCode, @IsActive)";

                        using (SqlCommand cmd = new SqlCommand(insertQuery, con))
                        {
                            cmd.Parameters.AddWithValue("@CollegeID", collegeId);
                            cmd.Parameters.AddWithValue("@DepartmentName", deptName);
                            cmd.Parameters.AddWithValue("@DepartmentCode", string.IsNullOrEmpty(deptCode) ? (object)DBNull.Value : deptCode);
                            cmd.Parameters.AddWithValue("@IsActive", isActive);

                            cmd.ExecuteNonQuery();
                        }

                        ShowMessage("Department added successfully.", true);
                    }
                }

                ResetForm();
                BindGrid(txtSearch.Text.Trim());
            }
            catch (SqlException sqlEx)
            {
                if (sqlEx.Number == 2627 || sqlEx.Number == 2601)
                    ShowMessage("Duplicate department name for this college. Please use a different name.", false);
                else
                    ShowMessage("Database error: " + sqlEx.Message, false);
            }
            catch (Exception ex)
            {
                ShowMessage("Error: " + ex.Message, false);
            }
        }

        #endregion

        #region Grid Row Commands (Edit / Delete)

        protected void gvDepartments_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int departmentId = 0;
            if (!int.TryParse(e.CommandArgument.ToString(), out departmentId) || departmentId <= 0)
                return;

            if (e.CommandName == "EditDept")
            {
                LoadDepartmentForEdit(departmentId);
            }
            else if (e.CommandName == "DeleteDept")
            {
                DeleteDepartment(departmentId);
            }
        }

        private void LoadDepartmentForEdit(int departmentId)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConnStr))
                {
                    string query = @"
                        SELECT DepartmentID, CollegeID, DepartmentName, DepartmentCode, IsActive 
                        FROM Departments 
                        WHERE DepartmentID = @DepartmentID";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@DepartmentID", departmentId);
                        con.Open();

                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                hfDepartmentID.Value = reader["DepartmentID"].ToString();
                                ddlCollege.SelectedValue = reader["CollegeID"].ToString();
                                txtDepartmentName.Text = reader["DepartmentName"].ToString();
                                txtDepartmentCode.Text = reader["DepartmentCode"] == DBNull.Value
                                    ? string.Empty
                                    : reader["DepartmentCode"].ToString();
                                chkIsActive.Checked = Convert.ToBoolean(reader["IsActive"]);

                                litFormTitle.Text = "Edit Department";
                                btnSave.Text = "Update Department";
                                btnCancel.Visible = true;
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading department: " + ex.Message, false);
            }
        }

        private void DeleteDepartment(int departmentId)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConnStr))
                {
                    con.Open();

                    // Check if any courses reference this department
                    string checkCourses = "SELECT COUNT(*) FROM Courses WHERE DepartmentID = @DepartmentID";
                    using (SqlCommand cmdCheck = new SqlCommand(checkCourses, con))
                    {
                        cmdCheck.Parameters.AddWithValue("@DepartmentID", departmentId);
                        int courseCount = Convert.ToInt32(cmdCheck.ExecuteScalar());

                        if (courseCount > 0)
                        {
                            ShowMessage("Cannot delete this department because " + courseCount +
                                        " course(s) are linked to it. Remove or reassign courses first.", false);
                            return;
                        }
                    }

                    // Check if any users reference this department (Users.Department is stored as nvarchar, but we can still check)
                    // Note: Users.Department is nvarchar(100) containing department name. Skip strict FK check here.

                    string deleteQuery = "DELETE FROM Departments WHERE DepartmentID = @DepartmentID";
                    using (SqlCommand cmd = new SqlCommand(deleteQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@DepartmentID", departmentId);
                        int rows = cmd.ExecuteNonQuery();

                        if (rows > 0)
                            ShowMessage("Department deleted successfully.", true);
                        else
                            ShowMessage("Department not found or already deleted.", false);
                    }
                }

                // If the deleted record was being edited, reset form
                int editingId = 0;
                int.TryParse(hfDepartmentID.Value, out editingId);
                if (editingId == departmentId)
                    ResetForm();

                BindGrid(txtSearch.Text.Trim());
            }
            catch (SqlException sqlEx)
            {
                if (sqlEx.Number == 547)
                    ShowMessage("Cannot delete this department because it is referenced by other records.", false);
                else
                    ShowMessage("Database error: " + sqlEx.Message, false);
            }
            catch (Exception ex)
            {
                ShowMessage("Error deleting department: " + ex.Message, false);
            }
        }

        #endregion

        #region Cancel / Reset

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            ResetForm();
        }

        private void ResetForm()
        {
            hfDepartmentID.Value = "0";
            ddlCollege.SelectedIndex = 0;
            txtDepartmentName.Text = string.Empty;
            txtDepartmentCode.Text = string.Empty;
            chkIsActive.Checked = true;

            litFormTitle.Text = "Add New Department";
            btnSave.Text = "Save Department";
            btnCancel.Visible = false;
        }

        #endregion

        #region Search

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            BindGrid(txtSearch.Text.Trim());
        }

        protected void btnClearSearch_Click(object sender, EventArgs e)
        {
            txtSearch.Text = string.Empty;
            BindGrid();
        }

        #endregion

        #region Paging

        protected void gvDepartments_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvDepartments.PageIndex = e.NewPageIndex;
            BindGrid(txtSearch.Text.Trim());
        }

        #endregion

        #region Helper - Show Message

        private void ShowMessage(string message, bool isSuccess)
        {
            pnlMessage.Visible = true;
            pnlMessage.CssClass = "message-alert " + (isSuccess ? "alert-success" : "alert-danger");
            pnlMessage.Controls.Clear();
            pnlMessage.Controls.Add(new LiteralControl(message));
        }

        #endregion
    }
}