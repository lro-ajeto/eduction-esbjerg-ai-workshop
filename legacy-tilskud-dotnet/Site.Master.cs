using System;
using System.Web;
using System.Web.UI;

namespace LegacyTilskud
{
    public partial class SiteMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            var userName = Convert.ToString(Session["UserName"]);
            if (string.IsNullOrWhiteSpace(userName))
            {
                pnlAuthenticated.Visible = false;
                return;
            }

            pnlAuthenticated.Visible = true;
            var role = Convert.ToString(Session["Role"]);
            var displayName = Convert.ToString(Session["DisplayName"]);
            litUser.Text = HttpUtility.HtmlEncode(displayName + " (" + role + ")");
        }
    }
}
