using System;
using System.Web;

namespace LegacyTilskud
{
    public class Global : HttpApplication
    {
        protected void Application_Start(object sender, EventArgs e)
        {
            // Database lifecycle is owned by the separate database project.
        }
    }
}
