<%@ Page Title="Rediger ansogning" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ApplicationEdit.aspx.cs" Inherits="LegacyTilskud.ApplicationEdit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <section class="legacy-panel">
        <h1 class="page-title"><asp:Literal ID="litPageTitle" runat="server" /></h1>
        <asp:ValidationSummary ID="valSummary" runat="server" CssClass="validation-summary" />
        <asp:Label ID="lblMessage" runat="server" CssClass="message" EnableViewState="false" />
        <asp:HiddenField ID="hidId" runat="server" />
        <div class="form-row">
            <div>
                <span class="field-label">Titel *</span>
                <asp:TextBox ID="txtTitle" runat="server" MaxLength="120" />
                <asp:RequiredFieldValidator ID="reqTitle" runat="server" ControlToValidate="txtTitle"
                    ErrorMessage="Titel er paakraevet." CssClass="field-error" Display="Dynamic" />
            </div>
        </div>
        <div class="form-row">
            <div>
                <span class="field-label">Ansogernavn *</span>
                <asp:TextBox ID="txtApplicant" runat="server" MaxLength="120" />
                <asp:RequiredFieldValidator ID="reqApplicant" runat="server" ControlToValidate="txtApplicant"
                    ErrorMessage="Ansogernavn er paakraevet." CssClass="field-error" Display="Dynamic" />
            </div>
            <div>
                <span class="field-label">Email</span>
                <asp:TextBox ID="txtEmail" runat="server" MaxLength="160" />
            </div>
        </div>
        <div class="form-row">
            <div>
                <span class="field-label">Omraade</span>
                <asp:TextBox ID="txtArea" runat="server" MaxLength="80" />
            </div>
            <div>
                <span class="field-label">Beloeb *</span>
                <asp:TextBox ID="txtAmount" runat="server" />
                <asp:RangeValidator ID="rngAmount" runat="server" ControlToValidate="txtAmount" Type="Currency"
                    MinimumValue="1000" MaximumValue="500000" ErrorMessage="Beloeb skal vaere mellem 1.000 og 500.000."
                    CssClass="field-error" Display="Dynamic" />
            </div>
        </div>
        <div class="form-row">
            <div>
                <span class="field-label">Beskrivelse</span>
                <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="7" />
            </div>
        </div>
        <div class="form-row">
            <div>
                <span class="field-label">Beslutningsnotat</span>
                <asp:TextBox ID="txtDecisionNote" runat="server" TextMode="MultiLine" Rows="3" />
            </div>
        </div>
        <div class="button-row">
            <asp:Button ID="btnSave" runat="server" Text="Gem" OnClick="btnSave_Click" />
            <asp:Button ID="btnCancel" runat="server" Text="Annuller" CausesValidation="false" OnClick="btnCancel_Click" CssClass="secondary-button" />
        </div>
    </section>
</asp:Content>
