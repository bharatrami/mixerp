<%@ Page Title="" Language="C#" MasterPageFile="~/ContentMaster.Master" AutoEventWireup="true" CodeBehind="Frequency.aspx.cs" Inherits="MixERP.net.FrontEnd.Setup.Frequency" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ScriptContentPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="StyleSheetContentPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="BodyContentPlaceHolder" runat="server">
    <pes:Form ID="FrequencySetupForm" runat="server" DenyAdd="false" DenyDelete="false" DenyEdit="false" KeyColumn="frequency_setup_id"
        PageSize="10" TableSchema="core" Table="frequency_setups" ViewSchema="core" View="frequency_setups" Text="Frequency Setup" Width="1000"
        DisplayFields="core.frequencies.frequency_id-->frequency_name" />
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="BottomScriptContentPlaceHolder" runat="server">
</asp:Content>
