<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="LegacyTilskud.Login" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title>Login - Tilskud Legacy</title>
    <link href="Content/site.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="login-box legacy-panel">
            <h1 class="page-title">Tilskud Legacy</h1>
            <p>Log ind med en workshop-bruger.</p>
            <asp:Label ID="lblError" runat="server" CssClass="message" EnableViewState="false" />
            <div class="form-row">
                <div>
                    <span class="field-label">Brugernavn</span>
                    <asp:TextBox ID="txtUsername" runat="server" />
                </div>
            </div>
            <div class="form-row">
                <div>
                    <span class="field-label">Password</span>
                    <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" />
                </div>
            </div>
            <asp:Button ID="btnLogin" runat="server" Text="Log ind" OnClick="btnLogin_Click" />
        </div>
    </form>
</body>
</html>
