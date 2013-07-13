<%@ Page Title="" Language="C#" MasterPageFile="~/ContentMaster.Master" AutoEventWireup="true" CodeBehind="AgentBonusSlabs.aspx.cs" Inherits="MixERP.net.FrontEnd.Sales.Setup.AgentBonusSlabs" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ScriptContentPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="StyleSheetContentPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="BodyContentPlaceHolder" runat="server">
    <pes:Form ID="BonusSlabForm" runat="server" DenyAdd="false" DenyDelete="false" DenyEdit="false" KeyColumn="bonus_slab_id"
        PageSize="10" TableSchema="core" Table="bonus_slabs" ViewSchema="core" View="bonus_slabs" Text="Agent Bonus Slabs" Width="1000"
        DisplayFields="core.frequencies.frequency_id-->frequency_name"
         />
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="BottomScriptContentPlaceHolder" runat="server">
</asp:Content>
