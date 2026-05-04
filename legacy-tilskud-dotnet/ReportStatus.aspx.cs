using System;
using LegacyTilskud.Data;
using LegacyTilskud.Security;

namespace LegacyTilskud
{
    public partial class ReportStatus : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            LegacySecurity.RequireLogin(this);

            if (!IsPostBack)
            {
                BindReport();
            }
        }

        private void BindReport()
        {
            var rows = new GrantApplicationRepository().GetStatusSummaries();
            rptStatus.DataSource = rows;
            rptStatus.DataBind();

            decimal total = 0;
            foreach (var row in rows)
            {
                total += row.TotalAmount;
            }

            lblTotal.Text = "Samlet ansogt beloeb: " + total.ToString("N0") + " kr.";
        }
    }
}
