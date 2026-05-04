<%@ Page Title="Statusrapport" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ReportStatus.aspx.cs" Inherits="LegacyTilskud.ReportStatus" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <section class="legacy-panel">
        <h1 class="page-title">Rapport: statusfordeling</h1>
        <p><asp:Label ID="lblTotal" runat="server" /></p>
        <asp:Repeater ID="rptStatus" runat="server">
            <HeaderTemplate>
                <table class="legacy-grid">
                    <tr>
                        <th>Status</th>
                        <th>Antal</th>
                        <th>Samlet beloeb</th>
                        <th>Fordeling</th>
                    </tr>
            </HeaderTemplate>
            <ItemTemplate>
                    <tr>
                        <td><span class='<%# "status-pill status-" + Eval("Status") %>'><%# Eval("Status") %></span></td>
                        <td><%# Eval("Count") %></td>
                        <td><%# Eval("TotalAmount", "{0:N0} kr.") %></td>
                        <td><div class="report-bar" style='<%# "width:" + Eval("BarWidth") + "%;" %>'></div></td>
                    </tr>
            </ItemTemplate>
            <FooterTemplate>
                </table>
            </FooterTemplate>
        </asp:Repeater>
    </section>
</asp:Content>
