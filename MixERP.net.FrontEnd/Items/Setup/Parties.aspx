<%-- 
Copyright (C) Binod Nepal, Mix Open Foundation (http://mixof.org).

This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. 
If a copy of the MPL was not distributed  with this file, You can obtain one at 
http://mozilla.org/MPL/2.0/.
--%>
<%@ Page Title="" Language="C#" MasterPageFile="~/ContentMaster.Master" AutoEventWireup="true" CodeBehind="Parties.aspx.cs" Inherits="MixERP.Net.FrontEnd.Items.Setup.Parties" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ScriptContentPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="StyleSheetContentPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="BodyContentPlaceHolder" runat="server">
    <mixerp:Form ID="PartyForm" runat="server"
        PageSize="10"
        TableSchema="core" Table="parties"
        KeyColumn="party_id"
        ViewSchema="core" View="party_view"
        Exclude=""
        DisplayFields="core.party_types.party_type_id-->party_type_code + ' (' + party_type_name + ')', core.frequencies.frequency_id-->frequency_code, core.accounts.account_id-->account_code + ' (' + account_name + ')' "
        SelectedValues="core.accounts.account_id-->'10400 (Accounts Receivable)'"
        Text="<%$Resources: Titles, PartyMaintenance %>"
        Width="4000"
        Description="<%$Resources:Labels, PartyDescription %>"
         />
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="BottomScriptContentPlaceHolder" runat="server">
</asp:Content>
