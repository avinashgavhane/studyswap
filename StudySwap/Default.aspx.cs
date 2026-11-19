using System;
using System.Web.UI;

namespace StudySwap
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["action"] == "logout")
            {
                Session.Clear();
                Session.Abandon();
                Response.Redirect("~/Default.aspx");
                return;
            }

            // If the user is already logged in, redirect them directly to their dashboard
            if (Session["UserID"] != null)
            {
                Response.Redirect("~/Student/StudentDashboard.aspx");
                return;
            }

            if (Session["Admin"] != null)
            {
                Response.Redirect("~/Admin/AdminDashboard.aspx");
                return;
            }

            // Guests see the full Home landing page (Default.aspx)
        }
    }
}
