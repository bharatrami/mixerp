<%@ Page Title="" Language="C#" MasterPageFile="~/ContentMaster.Master" AutoEventWireup="true" CodeBehind="Roles.aspx.cs" Inherits="MixERP.net.FrontEnd.Setup.Roles" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ScriptContentPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="StyleSheetContentPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="BodyContentPlaceHolder" runat="server">
    <pes:Form ID="RoleForm" runat="server" DenyAdd="false" DenyDelete="false" DenyEdit="false" KeyColumn="role_id"
        PageSize="10" TableSchema="office" Table="roles" ViewSchema="office" View="roles" Text="Role Maintenance" Width="1000" />
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="BottomScriptContentPlaceHolder" runat="server">
</asp:Content>
