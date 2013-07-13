<%@ Page Title="" Language="C#" MasterPageFile="~/ContentMaster.Master" AutoEventWireup="true" CodeBehind="StoreTypes.aspx.cs" Inherits="MixERP.net.FrontEnd.POS.Setup.StoreTypes" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ScriptContentPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="StyleSheetContentPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="BodyContentPlaceHolder" runat="server">
    <pes:Form ID="StoreTypeForm" runat="server" DenyAdd="false" DenyDelete="false" DenyEdit="false" KeyColumn="store_type_id"
        PageSize="10" TableSchema="office" Table="store_types" ViewSchema="office" View="store_types" Text="Store Types" Width="1000"
        DisplayFields=""
         />
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="BottomScriptContentPlaceHolder" runat="server">
</asp:Content>
