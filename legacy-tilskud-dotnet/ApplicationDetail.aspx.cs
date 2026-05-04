using System;
using System.Configuration;
using System.Web;
using System.Web.UI.WebControls;
using LegacyTilskud.Data;
using LegacyTilskud.Models;
using LegacyTilskud.Security;

namespace LegacyTilskud
{
    public partial class ApplicationDetail : System.Web.UI.Page
    {
        private readonly GrantApplicationRepository _repository = new GrantApplicationRepository();

        protected void Page_Load(object sender, EventArgs e)
        {
            LegacySecurity.RequireLogin(this);

            if (!IsPostBack)
            {
                BindStatusList();
                LoadApplication();
            }
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Default.aspx", true);
        }

        protected void btnEdit_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/ApplicationEdit.aspx?id=" + GetId(), true);
        }

        protected void btnChangeStatus_Click(object sender, EventArgs e)
        {
            if (!LegacySecurity.CanChangeStatus(this))
            {
                lblMessage.Text = "Din rolle maa ikke aendre status.";
                return;
            }

            if (ddlNewStatus.SelectedValue == "GODKENDT" && string.IsNullOrWhiteSpace(txtDecisionNote.Text))
            {
                lblMessage.Text = "Godkendelse kraever et kort beslutningsnotat.";
                return;
            }

            var ok = _repository.ChangeStatus(GetId(), ddlNewStatus.SelectedValue, LegacySecurity.CurrentUserName(this), txtDecisionNote.Text.Trim());
            lblMessage.Text = ok ? "Status er opdateret." : "Status kunne ikke opdateres. Sagen kan vaere afsluttet.";
            LoadApplication();
        }

        private void LoadApplication()
        {
            var application = _repository.GetById(GetId());
            if (application == null)
            {
                Response.Redirect("~/Default.aspx", true);
                return;
            }

            litId.Text = application.Id.ToString();
            lblTitle.Text = HttpUtility.HtmlEncode(application.Title);
            lblApplicant.Text = HttpUtility.HtmlEncode(application.ApplicantName);
            lblEmail.Text = HttpUtility.HtmlEncode(application.ApplicantEmail);
            lblArea.Text = HttpUtility.HtmlEncode(application.MunicipalityArea);
            lblAmount.Text = application.Amount.ToString("N0") + " kr.";
            lblStatus.Text = HttpUtility.HtmlEncode(application.Status);
            lblStatus.CssClass = "status-pill status-" + application.Status;
            litDescription.Text = HtmlLines(application.Description);
            litDecisionNote.Text = HtmlLines(application.DecisionNote);
            lblCreated.Text = application.CreatedAt.ToString("dd-MM-yyyy HH:mm");
            lblUpdated.Text = application.UpdatedAt.ToString("dd-MM-yyyy HH:mm");
            lblSubmitted.Text = application.SubmittedAt.HasValue ? application.SubmittedAt.Value.ToString("dd-MM-yyyy HH:mm") : "-";

            var canChangeStatus = LegacySecurity.CanChangeStatus(this);
            pnlStatusChange.Visible = canChangeStatus && !application.IsClosed;
            btnEdit.Visible = !application.IsClosed;
            lblStatusLocked.Visible = application.IsClosed || !canChangeStatus;
            lblStatusLocked.Text = application.IsClosed
                ? "Sagen er afsluttet og kan ikke redigeres."
                : "Du har laeseadgang og kan derfor ikke aendre status.";

            var item = ddlNewStatus.Items.FindByValue(application.Status);
            if (item != null)
            {
                ddlNewStatus.ClearSelection();
                item.Selected = true;
            }
        }

        private void BindStatusList()
        {
            ddlNewStatus.Items.Clear();
            var statuses = (ConfigurationManager.AppSettings["AllowedGrantStatuses"] ?? string.Empty).Split(',');
            foreach (var status in statuses)
            {
                ddlNewStatus.Items.Add(new ListItem(status, status));
            }
        }

        private int GetId()
        {
            int id;
            if (!int.TryParse(Request.QueryString["id"], out id))
            {
                Response.Redirect("~/Default.aspx", true);
            }

            return id;
        }

        private static string HtmlLines(string value)
        {
            return HttpUtility.HtmlEncode(value ?? string.Empty).Replace("\r\n", "<br />").Replace("\n", "<br />");
        }
    }
}
