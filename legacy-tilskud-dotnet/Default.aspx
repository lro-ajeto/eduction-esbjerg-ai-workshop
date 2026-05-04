<%@ Page Title="Ansogninger" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="LegacyTilskud.Default" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <section class="legacy-panel">
        <h1 class="page-title">Tilskudsansogninger</h1>
        <asp:Label ID="lblMessage" runat="server" CssClass="message" EnableViewState="false" />
        <div class="filter-row">
            <div>
                <span class="field-label">Sogning</span>
                <asp:TextBox ID="txtSearch" runat="server" />
            </div>
            <div>
                <span class="field-label">Status</span>
                <asp:DropDownList ID="ddlStatus" runat="server" />
            </div>
            <asp:Button ID="btnSearch" runat="server" Text="Sog" OnClick="btnSearch_Click" />
            <asp:Button ID="btnNew" runat="server" Text="Ny ansogning" OnClick="btnNew_Click" CssClass="secondary-button" />
        </div>
        <asp:GridView ID="gvApplications" runat="server" AutoGenerateColumns="False" CssClass="legacy-grid"
            GridLines="None" OnRowCommand="gvApplications_RowCommand">
            <Columns>
                <asp:BoundField DataField="Id" HeaderText="Id" />
                <asp:TemplateField HeaderText="Titel">
                    <ItemTemplate>
                        <asp:HyperLink ID="lnkDetail" runat="server"
                            NavigateUrl='<%# "ApplicationDetail.aspx?id=" + Eval("Id") %>'
                            Text='<%# Eval("Title") %>' />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="ApplicantName" HeaderText="Ansoger" />
                <asp:BoundField DataField="MunicipalityArea" HeaderText="Omraade" />
                <asp:BoundField DataField="Amount" HeaderText="Beloeb" DataFormatString="{0:N0} kr." HtmlEncode="False" />
                <asp:TemplateField HeaderText="Status">
                    <ItemTemplate>
                        <span class='<%# "status-pill status-" + Eval("Status") %>'><%# Eval("Status") %></span>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="UpdatedAt" HeaderText="Opdateret" DataFormatString="{0:dd-MM-yyyy HH:mm}" />
                <asp:TemplateField HeaderText="">
                    <ItemTemplate>
                        <asp:Button ID="btnEditRow" runat="server" Text="Rediger" CssClass="link-button"
                            CommandName="EditApplication" CommandArgument='<%# Eval("Id") %>' />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <EmptyDataTemplate>
                Ingen ansogninger matcher filteret.
            </EmptyDataTemplate>
        </asp:GridView>
    </section>
</asp:Content>
