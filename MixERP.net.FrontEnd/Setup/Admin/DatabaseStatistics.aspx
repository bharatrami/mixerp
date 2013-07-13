<%@ Page Title="" Language="C#" MasterPageFile="~/ContentMaster.Master" AutoEventWireup="true" CodeBehind="DatabaseStatistics.aspx.cs" Inherits="MixERP.net.FrontEnd.Setup.Admin.DatabaseStatistics" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ScriptContentPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="StyleSheetContentPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="BodyContentPlaceHolder" runat="server">
    <pes:Form ID="DBStatisticsForm" runat="server" DenyAdd="true" DenyDelete="true" DenyEdit="true" KeyColumn="relname"
        PageSize="500" TableSchema="public" Table="db_stat" ViewSchema="public" View="db_stat" Text="Database Statistics" Width="1800" />
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="BottomScriptContentPlaceHolder" runat="server">
</asp:Content>
