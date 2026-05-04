using System;
using System.Web;
using System.Web.UI;

namespace LegacyTilskud.Security
{
    public static class LegacySecurity
    {
        public static void RequireLogin(Page page)
        {
            if (page.Session["UserName"] != null)
            {
                return;
            }

            var returnUrl = HttpUtility.UrlEncode(page.Request.RawUrl);
            page.Response.Redirect("~/Login.aspx?returnUrl=" + returnUrl, true);
        }

        public static bool CanChangeStatus(Page page)
        {
            var role = Convert.ToString(page.Session["Role"]);
            return role == "admin" || role == "sagsbehandler";
        }

        public static string CurrentUserName(Page page)
        {
            return Convert.ToString(page.Session["UserName"]);
        }
    }
}
