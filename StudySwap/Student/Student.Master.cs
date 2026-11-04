using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data.SqlClient;

namespace StudySwap.Student
{
    public partial class Student : System.Web.UI.MasterPage
    {
        string conn = ConfigurationManager.ConnectionStrings["LIS"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            string Userid = Session["UserID"].ToString();
            using(SqlConnection con = new SqlConnection(conn))
            {
                con.Open();
                string query = @"select FullName from Users where UserID=@userid";
                using(SqlCommand cmd = new SqlCommand(query,con))
                {
                    cmd.Parameters.AddWithValue("@userid", Userid);

                    object result = cmd.ExecuteScalar();

                    if(result!=null)
                    {
                        string fullname = result.ToString();
                        lblname.Text = fullname;
                    }
                    else
                    {
                        lblname.Text = Userid;
                    }
                }
            }
        }
    }
}
