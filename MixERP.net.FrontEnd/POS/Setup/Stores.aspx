<%@ Page Title="" Language="C#" MasterPageFile="~/ContentMaster.Master" AutoEventWireup="true" CodeBehind="Stores.aspx.cs" Inherits="MixERP.net.FrontEnd.POS.Setup.Stores" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ScriptContentPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="StyleSheetContentPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="BodyContentPlaceHolder" runat="server">
    <pes:Form ID="StoreForm" runat="server" DenyAdd="false" DenyDelete="false" DenyEdit="false" KeyColumn="store_id"
        PageSize="10" TableSchema="office" Table="stores" ViewSchema="office" View="stores" Text="Store Maintenance" Width="1000"
        DisplayFields="office.store_types.store_type_id-->store_type_name,office.offices.office_id-->office_name"
         />
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="BottomScriptContentPlaceHolder" runat="server">
</asp:Content>
