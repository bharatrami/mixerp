<%@ Page Title="" Language="C#" MasterPageFile="~/ContentMaster.Master" AutoEventWireup="true" CodeBehind="CUOM.aspx.cs" Inherits="MixERP.net.FrontEnd.Items.Setup.CUOM" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ScriptContentPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="StyleSheetContentPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="BodyContentPlaceHolder" runat="server">
    <pes:Form ID="CompoundUnitForm" runat="server" DenyAdd="false" DenyDelete="false" DenyEdit="false" KeyColumn="compound_unit_id"
        PageSize="10" TableSchema="core" Table="compound_units" ViewSchema="core" View="compound_units" Text="Compound Unit of Measure" Width="1000"
        DisplayFields="core.units.unit_id-->unit_name"
         />
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="BottomScriptContentPlaceHolder" runat="server">
</asp:Content>
