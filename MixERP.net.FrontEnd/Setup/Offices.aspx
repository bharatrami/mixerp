<%@ Page Title="" Language="C#" MasterPageFile="~/ContentMaster.Master" AutoEventWireup="true" CodeBehind="Offices.aspx.cs" Inherits="MixERP.net.FrontEnd.Setup.Offices" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ScriptContentPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="StyleSheetContentPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="BodyContentPlaceHolder" runat="server">
    <pes:Form ID="OfficeForm" runat="server" DenyAdd="false" DenyDelete="true" DenyEdit="true" KeyColumn="office_id" DisplayFields="office.offices.office_id-->office_name"
        PageSize="10" TableSchema="office" Table="offices" ViewSchema="office" View="offices" Text="Office Setup" Width="4000" />
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="BottomScriptContentPlaceHolder" runat="server">
</asp:Content>
