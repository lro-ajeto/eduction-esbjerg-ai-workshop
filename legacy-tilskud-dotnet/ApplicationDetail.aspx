<%@ Page Title="Ansogning" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ApplicationDetail.aspx.cs" Inherits="LegacyTilskud.ApplicationDetail" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <section class="legacy-panel">
        <h1 class="page-title">Ansogning #<asp:Literal ID="litId" runat="server" /></h1>
        <asp:Label ID="lblMessage" runat="server" CssClass="message" EnableViewState="false" />
        <table class="detail-table">
            <tr>
                <th>Titel</th>
                <td><asp:Label ID="lblTitle" runat="server" /></td>
            </tr>
            <tr>
                <th>Ansoger</th>
                <td><asp:Label ID="lblApplicant" runat="server" /></td>
            </tr>
            <tr>
                <th>Email</th>
                <td><asp:Label ID="lblEmail" runat="server" /></td>
            </tr>
            <tr>
                <th>Omraade</th>
                <td><asp:Label ID="lblArea" runat="server" /></td>
            </tr>
            <tr>
                <th>Beloeb</th>
                <td><asp:Label ID="lblAmount" runat="server" /></td>
            </tr>
            <tr>
                <th>Status</th>
                <td><asp:Label ID="lblStatus" runat="server" CssClass="status-pill" /></td>
            </tr>
            <tr>
                <th>Beskrivelse</th>
                <td><asp:Literal ID="litDescription" runat="server" /></td>
            </tr>
            <tr>
                <th>Beslutningsnotat</th>
                <td><asp:Literal ID="litDecisionNote" runat="server" /></td>
            </tr>
            <tr>
                <th>Datoer</th>
                <td>
                    Oprettet: <asp:Label ID="lblCreated" runat="server" /><br />
                    Opdateret: <asp:Label ID="lblUpdated" runat="server" /><br />
                    Indsendt: <asp:Label ID="lblSubmitted" runat="server" />
                </td>
            </tr>
        </table>
        <div class="button-row">
            <asp:Button ID="btnBack" runat="server" Text="Tilbage" OnClick="btnBack_Click" CssClass="secondary-button" />
            <asp:Button ID="btnEdit" runat="server" Text="Rediger" OnClick="btnEdit_Click" />
        </div>
        <asp:Panel ID="pnlStatusChange" runat="server" CssClass="legacy-panel">
            <h2>Skift status</h2>
            <div class="form-row">
                <div>
                    <span class="field-label">Ny status</span>
                    <asp:DropDownList ID="ddlNewStatus" runat="server" />
                </div>
                <div>
                    <span class="field-label">Notat</span>
                    <asp:TextBox ID="txtDecisionNote" runat="server" TextMode="MultiLine" Rows="3" />
                </div>
            </div>
            <asp:Button ID="btnChangeStatus" runat="server" Text="Gem status" CssClass="js-confirm-status" OnClick="btnChangeStatus_Click" />
        </asp:Panel>
        <asp:Label ID="lblStatusLocked" runat="server" CssClass="message" Visible="false" />
    </section>
</asp:Content>
