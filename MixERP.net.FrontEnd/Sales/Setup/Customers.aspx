<%-- 
    Copyright (C) Binod Nepal, Planet Earth Solutions Pvt. Ltd., Kathmandu.
	Released under the terms of the GNU General Public License, GPL, 
	as published by the Free Software Foundation, either version 3 
	of the License, or (at your option) any later version.
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
    See the License here <http://www.gnu.org/licenses/gpl-3.0.html>.
--%>
<%@ Page Title="" Language="C#" MasterPageFile="~/ContentMaster.Master" AutoEventWireup="true" CodeBehind="Customers.aspx.cs" Inherits="MixERP.net.FrontEnd.Sales.Setup.Customers" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ScriptContentPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="StyleSheetContentPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="BodyContentPlaceHolder" runat="server">
    <pes:Form ID="CustomerForm" runat="server" Text="Customer Maintenance" TableSchema="core" Table="customers" KeyColumn="customer_id"
        ViewSchema="core" View="customers" Width="5000" PageSize="10"
        Exclude="customer_code, customer_name"
        SelectedValues="core.customer_types.customer_type_id-->'C (Customer)', core.frequencies.frequency_id-->'EOQ (End of Quarter)', core.accounts.account_id-->'10400 (Accounts Receivable)'"
        DisplayFields="core.customer_types.customer_type_id-->customer_type_code + ' (' + customer_type_name + ')', core.frequencies.frequency_id-->frequency_code + ' (' + frequency_name + ')', core.accounts.account_id-->account_code + ' (' + account_name + ')'" />
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="BottomScriptContentPlaceHolder" runat="server">
</asp:Content>
