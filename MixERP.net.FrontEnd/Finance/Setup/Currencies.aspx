<%@ Page Title="" Language="C#" MasterPageFile="~/ContentMaster.Master" AutoEventWireup="true" CodeBehind="Currencies.aspx.cs" Inherits="MixERP.net.FrontEnd.Finance.Setup.Currencies" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ScriptContentPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="StyleSheetContentPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="BodyContentPlaceHolder" runat="server">
    <pes:Form ID="CurrencyForm" runat="server" DenyAdd="false" DenyDelete="false" DenyEdit="false" KeyColumn="currency_code"
        PageSize="10" TableSchema="core" Table="currencies" ViewSchema="core" View="currencies" Text="Currency Maintenace" Width="1100" />
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="BottomScriptContentPlaceHolder" runat="server">
</asp:Content>
