using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace StudySwap.Admin
{
    public partial class AddCategory : System.Web.UI.Page
    {
        private string connStr = ConfigurationManager.ConnectionStrings["LIS"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindCategories();
            }
        }

        // ==========================
        // BIND CATEGORY GRID
        // ==========================
        private void BindCategories()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"SELECT CategoryID, CategoryName, Description,   IsActive 
                                 FROM Categories 
                                 ORDER BY DisplayOrder ASC, CategoryID ASC";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        gvCategories.DataSource = dt;
                        gvCategories.DataBind();
                    }
                }
            }
        }

        // ==========================
        // SAVE (ADD / UPDATE)
        // ==========================
        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            string categoryName = txtCategoryName.Text.Trim();
            string description = txtDescription.Text.Trim();
           
            int displayOrder = 0;
         
            bool isActive = chkIsActive.Checked;

            if (string.IsNullOrEmpty(categoryName))
            {
                ShowMessage("Category Name is required.", false);
                return;
            }

            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();

                    if (!string.IsNullOrEmpty(hdnCategoryID.Value))
                    {
                        // ---------- UPDATE ----------
                        int categoryId = Convert.ToInt32(hdnCategoryID.Value);

                        string updateQuery = @"UPDATE Categories 
                                               SET CategoryName = @CategoryName,
                                                   Description = @Description,
                                                  
                                                 
                                                   IsActive = @IsActive
                                               WHERE CategoryID = @CategoryID";

                        using (SqlCommand cmd = new SqlCommand(updateQuery, con))
                        {
                            cmd.Parameters.AddWithValue("@CategoryName", categoryName);
                            cmd.Parameters.AddWithValue("@Description", (object)description ?? DBNull.Value);
                          //  cmd.Parameters.AddWithValue("@IconPath", (object)iconPath ?? DBNull.Value);
                           // cmd.Parameters.AddWithValue("@DisplayOrder", displayOrder);
                            cmd.Parameters.AddWithValue("@IsActive", isActive);
                            cmd.Parameters.AddWithValue("@CategoryID", categoryId);

                            cmd.ExecuteNonQuery();
                        }

                        ShowMessage("✅ Category updated successfully.", true);
                        ResetForm();
                    }
                    else
                    {
                        // ---------- INSERT ----------
                        string insertQuery = @"INSERT INTO Categories 
                                              (CategoryName, Description,IsActive)
                                              VALUES 
                                              (@CategoryName, @Description,  @DisplayOrder, @IsActive)";

                        using (SqlCommand cmd = new SqlCommand(insertQuery, con))
                        {
                            cmd.Parameters.AddWithValue("@CategoryName", categoryName);
                            cmd.Parameters.AddWithValue("@Description", (object)description ?? DBNull.Value);
                            //cmd.Parameters.AddWithValue("@IconPath", (object)iconPath ?? DBNull.Value);
                            //cmd.Parameters.AddWithValue("@DisplayOrder", displayOrder);
                            cmd.Parameters.AddWithValue("@IsActive", isActive);

                            cmd.ExecuteNonQuery();
                        }

                        ShowMessage("✅ Category added successfully.", true);
                        ResetForm();
                    }
                }

                BindCategories();
            }
            catch (SqlException ex)
            {
                if (ex.Number == 2627)
                {
                    ShowMessage("⚠️ A category with this name already exists.", false);
                }
                else
                {
                    ShowMessage("❌ Database error: " + ex.Message, false);
                }
            }
            catch (Exception ex)
            {
                ShowMessage("❌ Error: " + ex.Message, false);
            }
        }

        // ==========================
        // GRIDVIEW ROW COMMANDS
        // ==========================
        protected void gvCategories_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditCategory")
            {
                int categoryId = Convert.ToInt32(e.CommandArgument);
                LoadCategoryForEdit(categoryId);
            }
            else if (e.CommandName == "DeleteCategory")
            {
                int categoryId = Convert.ToInt32(e.CommandArgument);
                DeleteCategory(categoryId);
            }
        }

        // ==========================
        // LOAD CATEGORY FOR EDIT
        // ==========================
        private void LoadCategoryForEdit(int categoryId)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    string query = @"SELECT CategoryID, CategoryName, Description,   IsActive 
                                     FROM Categories 
                                     WHERE CategoryID = @CategoryID";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@CategoryID", categoryId);
                        con.Open();

                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                hdnCategoryID.Value = reader["CategoryID"].ToString();
                                txtCategoryName.Text = reader["CategoryName"].ToString();
                                txtDescription.Text = reader["Description"] != DBNull.Value ? reader["Description"].ToString() : "";
                         //       txtIconPath.Text = reader["IconPath"] != DBNull.Value ? reader["IconPath"].ToString() : "";
                              //  txtDisplayOrder.Text = reader["DisplayOrder"] != DBNull.Value ? reader["DisplayOrder"].ToString() : "0";
                                chkIsActive.Checked = reader["IsActive"] != DBNull.Value && Convert.ToBoolean(reader["IsActive"]);

                                lblFormTitle.Text = "Edit Category";
                                btnSave.Text = "Update Category";
                                btnCancelEdit.Visible = true;
                                editModeIndicator.Attributes["class"] = "edit-mode-indicator active";
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("❌ Error loading category: " + ex.Message, false);
            }
        }

        // ==========================
        // DELETE CATEGORY (WITH PRODUCT CHECK)
        // ==========================
        private void DeleteCategory(int categoryId)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();

                    // ------------------------------------------------------------
                    // STEP 1: Check if any products exist under this category
                    // ------------------------------------------------------------
                    int productCount = 0;
                    string countQuery = "SELECT COUNT(*) FROM Products WHERE CategoryID = @CategoryID";

                    using (SqlCommand cmdCount = new SqlCommand(countQuery, con))
                    {
                        cmdCount.Parameters.AddWithValue("@CategoryID", categoryId);
                        productCount = Convert.ToInt32(cmdCount.ExecuteScalar());
                    }

                    if (productCount > 0)
                    {
                        // Block the delete and inform admin
                        ShowMessage(
                            string.Format("⚠️ Cannot delete this category. It contains {0} product(s). " +
                                          "Please move or delete those products first.",
                                          productCount),
                            false
                        );
                        return; // Stop here — do not delete
                    }

                    // ------------------------------------------------------------
                    // STEP 2: Safe to delete
                    // ------------------------------------------------------------
                    string deleteQuery = "DELETE FROM Categories WHERE CategoryID = @CategoryID";

                    using (SqlCommand cmd = new SqlCommand(deleteQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@CategoryID", categoryId);
                        int rows = cmd.ExecuteNonQuery();

                        if (rows > 0)
                        {
                            ShowMessage("🗑️ Category deleted successfully.", true);
                        }
                        else
                        {
                            ShowMessage("⚠️ Category not found.", false);
                        }
                    }
                }

                // If we were editing this category, reset the form
                if (hdnCategoryID.Value == categoryId.ToString())
                {
                    ResetForm();
                }

                BindCategories();
            }
            catch (SqlException ex)
            {
                // Safety net in case FK constraint fires anyway (e.g. other related tables)
                if (ex.Number == 547)
                {
                    ShowMessage("⚠️ Cannot delete this category because it is referenced by other records.", false);
                }
                else
                {
                    ShowMessage("❌ Database error: " + ex.Message, false);
                }
            }
            catch (Exception ex)
            {
                ShowMessage("❌ Error: " + ex.Message, false);
            }
        }

        // ==========================
        // CANCEL EDIT
        // ==========================
        protected void btnCancelEdit_Click(object sender, EventArgs e)
        {
            ResetForm();
        }

        // ==========================
        // RESET FORM
        // ==========================
        private void ResetForm()
        {
            hdnCategoryID.Value = "";
            txtCategoryName.Text = "";
            txtDescription.Text = "";
          
          //  txtDisplayOrder.Text = "";
            chkIsActive.Checked = true;

            lblFormTitle.Text = "Add New Category";
            btnSave.Text = "Add Category";
            btnCancelEdit.Visible = false;
            editModeIndicator.Attributes["class"] = "edit-mode-indicator";
        }

        // ==========================
        // SHOW MESSAGE
        // ==========================
        private void ShowMessage(string message, bool isSuccess)
        {
            lblMessage.Text = message;
            lblMessage.ForeColor = isSuccess
                ? System.Drawing.Color.Green
                : System.Drawing.Color.Red;
        }
    }
}