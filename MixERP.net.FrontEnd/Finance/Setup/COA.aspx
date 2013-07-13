<%@ Page Title="" Language="C#" MasterPageFile="~/ContentMaster.Master" AutoEventWireup="true" CodeBehind="COA.aspx.cs" Inherits="MixERP.net.FrontEnd.Finance.Setup.COA" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ScriptContentPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="StyleSheetContentPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="BodyContentPlaceHolder" runat="server">
    <pes:Form ID="AccountTypeForm" runat="server" Text="Chart of Accounts" TableSchema="core" Table="accounts" KeyColumn="account_id"
        ViewSchema="core" View="accounts_view" Width="2000" PageSize="10" 
        DisplayFields="core.account_masters.account_master_id-->account_master_code + ' (' + account_master_name + ')',core.accounts.account_id-->account_code + ' (' + account_name + ')'" />
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="BottomScriptContentPlaceHolder" runat="server">
</asp:Content>
