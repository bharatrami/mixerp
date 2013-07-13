<%@ Page Title="" Language="C#" MasterPageFile="~/ContentMaster.Master" AutoEventWireup="true" CodeBehind="UOM.aspx.cs" Inherits="MixERP.net.FrontEnd.Items.Setup.UOM" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ScriptContentPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="StyleSheetContentPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="BodyContentPlaceHolder" runat="server">
    <pes:Form ID="UnitForm" runat="server" DenyAdd="false" DenyDelete="false" DenyEdit="false" KeyColumn="unit_id"
        PageSize="10" TableSchema="core" Table="units" ViewSchema="core" View="units" Text="Unit of Measure" Width="1000" />
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="BottomScriptContentPlaceHolder" runat="server">
</asp:Content>
