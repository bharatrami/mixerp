﻿<%@ Page Title="" Language="C#" MasterPageFile="~/ContentMaster.Master" AutoEventWireup="true" CodeBehind="Agents.aspx.cs" Inherits="MixERP.net.FrontEnd.Sales.Setup.Agents" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ScriptContentPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="StyleSheetContentPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="BodyContentPlaceHolder" runat="server">
    <pes:Form ID="AgentSlabForm" runat="server" DenyAdd="false" DenyDelete="false" DenyEdit="false" KeyColumn="agent_id"
        PageSize="10" TableSchema="core" Table="agents" ViewSchema="core" View="agents" Text="Agent Setup" Width="1000"
        DisplayFields="core.accounts.account_id-->account_code + ' (' + account_name + ')'"
         />
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="BottomScriptContentPlaceHolder" runat="server">
</asp:Content>
