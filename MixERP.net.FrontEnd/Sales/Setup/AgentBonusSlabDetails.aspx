<%@ Page Title="" Language="C#" MasterPageFile="~/ContentMaster.Master" AutoEventWireup="true" CodeBehind="AgentBonusSlabDetails.aspx.cs" Inherits="MixERP.net.FrontEnd.Sales.Setup.AgentBonusSlabDetails" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ScriptContentPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="StyleSheetContentPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="BodyContentPlaceHolder" runat="server">
    <pes:Form ID="BonusSlabDetailsForm" runat="server" DenyAdd="false" DenyDelete="false" DenyEdit="false" KeyColumn="bonus_slab_detail_id"
        PageSize="10" TableSchema="core" Table="bonus_slab_details" ViewSchema="core" View="bonus_slab_details" Text="Bonus Slab Details" Width="1000"
        DisplayFields="core.bonus_slabs.bonus_slab_id-->bonus_slab_name"
         />
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="BottomScriptContentPlaceHolder" runat="server">
</asp:Content>
