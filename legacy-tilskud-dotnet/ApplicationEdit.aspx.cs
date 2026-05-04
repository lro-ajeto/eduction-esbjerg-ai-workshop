using System;
using System.Configuration;
using System.Globalization;
using LegacyTilskud.Data;
using LegacyTilskud.Models;
using LegacyTilskud.Security;

namespace LegacyTilskud
{
    public partial class ApplicationEdit : System.Web.UI.Page
    {
        private readonly GrantApplicationRepository _repository = new GrantApplicationRepository();

        protected void Page_Load(object sender, EventArgs e)
        {
            LegacySecurity.RequireLogin(this);

            if (!IsPostBack)
            {
                LoadFromQuery();
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
            {
                return;
            }

            decimal amount;
            if (!TryParseAmount(txtAmount.Text, out amount))
            {
                lblMessage.Text = "Beloeb kunne ikke laeses som et tal.";
                return;
            }

            var min = decimal.Parse(ConfigurationManager.AppSettings["MinimumGrantAmount"]);
            var max = decimal.Parse(ConfigurationManager.AppSettings["MaximumGrantAmount"]);
            if (amount < min || amount > max)
            {
                lblMessage.Text = "Beloeb skal vaere mellem 1.000 og 500.000.";
                return;
            }

            var application = new GrantApplication
            {
                Id = GetCurrentId(),
                Title = txtTitle.Text.Trim(),
                ApplicantName = txtApplicant.Text.Trim(),
                ApplicantEmail = txtEmail.Text.Trim(),
                MunicipalityArea = txtArea.Text.Trim(),
                Amount = amount,
                Description = txtDescription.Text.Trim(),
                DecisionNote = txtDecisionNote.Text.Trim()
            };

            if (application.Id > 0)
            {
                var ok = _repository.Update(application, LegacySecurity.CurrentUserName(this));
                if (!ok)
                {
                    lblMessage.Text = "Ansogningen kunne ikke gemmes. Den er sandsynligvis afsluttet.";
                    return;
                }

                Response.Redirect("~/ApplicationDetail.aspx?id=" + application.Id, true);
            }
            else
            {
                var newId = _repository.Insert(application, LegacySecurity.CurrentUserName(this));
                Response.Redirect("~/ApplicationDetail.aspx?id=" + newId, true);
            }
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            var id = GetCurrentId();
            Response.Redirect(id > 0 ? "~/ApplicationDetail.aspx?id=" + id : "~/Default.aspx", true);
        }

        private void LoadFromQuery()
        {
            int id;
            if (!int.TryParse(Request.QueryString["id"], out id))
            {
                litPageTitle.Text = "Ny ansogning";
                return;
            }

            var application = _repository.GetById(id);
            if (application == null)
            {
                Response.Redirect("~/Default.aspx", true);
                return;
            }

            hidId.Value = application.Id.ToString();
            litPageTitle.Text = "Rediger ansogning #" + application.Id;
            txtTitle.Text = application.Title;
            txtApplicant.Text = application.ApplicantName;
            txtEmail.Text = application.ApplicantEmail;
            txtArea.Text = application.MunicipalityArea;
            txtAmount.Text = application.Amount.ToString("N0");
            txtDescription.Text = application.Description;
            txtDecisionNote.Text = application.DecisionNote;

            if (application.IsClosed)
            {
                lblMessage.Text = "GODKENDT og AFVIST ansogninger maa ikke redigeres.";
                SetFormEnabled(false);
            }
        }

        private int GetCurrentId()
        {
            int id;
            return int.TryParse(hidId.Value, out id) ? id : 0;
        }

        private void SetFormEnabled(bool enabled)
        {
            txtTitle.Enabled = enabled;
            txtApplicant.Enabled = enabled;
            txtEmail.Enabled = enabled;
            txtArea.Enabled = enabled;
            txtAmount.Enabled = enabled;
            txtDescription.Enabled = enabled;
            txtDecisionNote.Enabled = enabled;
            btnSave.Visible = enabled;
        }

        private static bool TryParseAmount(string text, out decimal amount)
        {
            var da = CultureInfo.GetCultureInfo("da-DK");
            return decimal.TryParse(text, NumberStyles.Number, da, out amount)
                || decimal.TryParse(text, NumberStyles.Number, CultureInfo.InvariantCulture, out amount);
        }
    }
}
