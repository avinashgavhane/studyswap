using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace StudySwap.Admin
{
    public partial class AddCollegeData : System.Web.UI.Page
    {
        private string ConnStr =>
            ConfigurationManager.ConnectionStrings["LIS"].ConnectionString;

        private int EditingCollegeID
        {
            get { return ViewState["EditingCollegeID"] == null ? 0 : (int)ViewState["EditingCollegeID"]; }
            set { ViewState["EditingCollegeID"] = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindColleges();
                SetAddMode();
            }
        }

        #region Mode helpers

        private void SetAddMode()
        {
            EditingCollegeID = 0;
            hfCollegeID.Value = "0";
            litFormTitle.Text = "Add New College";
            btnSave.Text = "Save College";
            btnCancel.Visible = false;
            ClearFields();
        }

        private void SetEditMode(int collegeId)
        {
            EditingCollegeID = collegeId;
            hfCollegeID.Value = collegeId.ToString();
            litFormTitle.Text = "Edit College #" + collegeId;
            btnSave.Text = "Update College";
            btnCancel.Visible = true;
        }

        #endregion

        #region Load / Bind

        private void BindColleges()
        {
            using (SqlConnection con = new SqlConnection(ConnStr))
            {
                string query = @"SELECT TOP (1000) [CollegeID]
                                      ,[CollegeName]
                                      ,[EmailDomain]
                                      ,[City]
                                      ,[State]
                                      ,[IsActive]
                                      ,[CreatedDate]
                                 FROM [StudySwap].[dbo].[Colleges]
                                 ORDER BY [CollegeID] DESC";

                using (SqlDataAdapter da = new SqlDataAdapter(query, con))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    gvColleges.DataSource = dt;
                    gvColleges.DataBind();
                }
            }
        }

        private void LoadCollegeIntoForm(int collegeId)
        {
            using (SqlConnection con = new SqlConnection(ConnStr))
            {
                string query = @"SELECT [CollegeID],[CollegeName],[EmailDomain],[City],[State],[IsActive]
                                 FROM [StudySwap].[dbo].[Colleges]
                                 WHERE [CollegeID] = @CollegeID";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@CollegeID", collegeId);
                    con.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            txtCollegeName.Text = dr["CollegeName"] as string ?? "";
                            txtEmailDomain.Text = dr["EmailDomain"] as string ?? "";
                            txtCity.Text = dr["City"] as string ?? "";
                            txtState.Text = dr["State"] as string ?? "";
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
            if (string.IsNullOrWhiteSpace(txtCollegeName.Text))
            {
                lblMsg.ForeColor = System.Drawing.Color.Red;
                lblMsg.Text = "College Name is required.";
                return;
            }

            try
            {
                if (EditingCollegeID > 0)
                    UpdateCollege(EditingCollegeID);
                else
                    InsertCollege();

                BindColleges();
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

        private void InsertCollege()
        {
            using (SqlConnection con = new SqlConnection(ConnStr))
            {
                string query = @"INSERT INTO [StudySwap].[dbo].[Colleges]
                                    ([CollegeName],[EmailDomain],[City],[State],[IsActive],[CreatedDate])
                                 VALUES
                                    (@CollegeName,@EmailDomain,@City,@State,@IsActive,GETDATE())";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@CollegeName", txtCollegeName.Text.Trim());
                    cmd.Parameters.AddWithValue("@EmailDomain", (object)txtEmailDomain.Text.Trim() ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@City", (object)txtCity.Text.Trim() ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@State", (object)txtState.Text.Trim() ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@IsActive", chkIsActive.Checked);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        private void UpdateCollege(int collegeId)
        {
            using (SqlConnection con = new SqlConnection(ConnStr))
            {
                string query = @"UPDATE [StudySwap].[dbo].[Colleges]
                                    SET [CollegeName] = @CollegeName,
                                        [EmailDomain] = @EmailDomain,
                                        [City]        = @City,
                                        [State]       = @State,
                                        [IsActive]    = @IsActive
                                  WHERE [CollegeID]   = @CollegeID";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@CollegeName", txtCollegeName.Text.Trim());
                    cmd.Parameters.AddWithValue("@EmailDomain", (object)txtEmailDomain.Text.Trim() ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@City", (object)txtCity.Text.Trim() ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@State", (object)txtState.Text.Trim() ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@IsActive", chkIsActive.Checked);
                    cmd.Parameters.AddWithValue("@CollegeID", collegeId);

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
            txtCollegeName.Text = string.Empty;
            txtEmailDomain.Text = string.Empty;
            txtCity.Text = string.Empty;
            txtState.Text = string.Empty;
            chkIsActive.Checked = true;
        }

        #endregion

        #region GridView events

        protected void gvColleges_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvColleges.PageIndex = e.NewPageIndex;
            BindColleges();
        }

        protected void gvColleges_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditCollege")
            {
                int collegeId = Convert.ToInt32(e.CommandArgument);
                LoadCollegeIntoForm(collegeId);
                SetEditMode(collegeId);

                lblMsg.ForeColor = System.Drawing.Color.DarkOrange;
                lblMsg.Text = "Editing College #" + collegeId + ". Change and click Update.";
            }
        }

        protected void gvColleges_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int collegeId = Convert.ToInt32(gvColleges.DataKeys[e.RowIndex].Value);

            try
            {
                using (SqlConnection con = new SqlConnection(ConnStr))
                {
                    string query = "DELETE FROM [StudySwap].[dbo].[Colleges] WHERE [CollegeID] = @CollegeID";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@CollegeID", collegeId);
                        con.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                if (EditingCollegeID == collegeId)
                    SetAddMode();

                BindColleges();
                lblMsg.ForeColor = System.Drawing.Color.Green;
                lblMsg.Text = "College deleted successfully.";
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