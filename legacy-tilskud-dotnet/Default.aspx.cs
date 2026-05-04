using System;
using System.Configuration;
using LegacyTilskud.Data;
using LegacyTilskud.Security;

namespace LegacyTilskud
{
    public partial class Default : System.Web.UI.Page
    {
        private readonly GrantApplicationRepository _repository = new GrantApplicationRepository();

        protected void Page_Load(object sender, EventArgs e)
        {
            LegacySecurity.RequireLogin(this);

            if (!IsPostBack)
            {
                BindStatusFilter();
                BindApplications();
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            BindApplications();
        }

        protected void btnNew_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/ApplicationEdit.aspx", true);
        }

        protected void gvApplications_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditApplication")
            {
                Response.Redirect("~/ApplicationEdit.aspx?id=" + e.CommandArgument, true);
            }
        }

        private void BindStatusFilter()
        {
            ddlStatus.Items.Clear();
            ddlStatus.Items.Add(new System.Web.UI.WebControls.ListItem("Alle", string.Empty));

            var statuses = (ConfigurationManager.AppSettings["AllowedGrantStatuses"] ?? string.Empty).Split(',');
            foreach (var status in statuses)
            {
                ddlStatus.Items.Add(new System.Web.UI.WebControls.ListItem(status, status));
            }
        }

        private void BindApplications()
        {
            var rows = _repository.Search(txtSearch.Text.Trim(), ddlStatus.SelectedValue);
            gvApplications.DataSource = rows;
            gvApplications.DataBind();
            lblMessage.Text = rows.Count + " ansogning(er) fundet.";
        }
    }
}
