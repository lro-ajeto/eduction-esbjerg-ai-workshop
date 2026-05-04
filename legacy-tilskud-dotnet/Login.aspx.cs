using System;
using LegacyTilskud.Data;

namespace LegacyTilskud
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && Session["UserName"] != null)
            {
                Response.Redirect("~/Default.aspx", true);
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            var username = txtUsername.Text.Trim();
            var password = txtPassword.Text;

            var user = new AuthRepository().FindUser(username, password);
            if (user == null)
            {
                lblError.Text = "Forkert brugernavn eller password.";
                return;
            }

            Session["UserName"] = user.Username;
            Session["DisplayName"] = user.DisplayName;
            Session["Role"] = user.RoleName;

            var returnUrl = Request.QueryString["returnUrl"];
            if (!string.IsNullOrWhiteSpace(returnUrl) && returnUrl.StartsWith("/", StringComparison.Ordinal))
            {
                Response.Redirect(returnUrl, true);
            }

            Response.Redirect("~/Default.aspx", true);
        }
    }
}
