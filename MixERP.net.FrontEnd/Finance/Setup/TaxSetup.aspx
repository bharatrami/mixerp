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
<%@ Page Title="" Language="C#" MasterPageFile="~/ContentMaster.Master" AutoEventWireup="true" CodeBehind="TaxSetup.aspx.cs" Inherits="MixERP.Net.FrontEnd.Finance.Setup.TaxSetup" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ScriptContentPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="StyleSheetContentPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="BodyContentPlaceHolder" runat="server">
    <pes:Form ID="TaxForm" runat="server" Text="Tax Setup" TableSchema="core" Table="taxes" KeyColumn="tax_id"
        ViewSchema="core" View="tax_view" Width="1000" PageSize="10" 
        SelectedValues="core.accounts.account_id-->'20700 (Tax Payables)' "
        DisplayFields="core.tax_types.tax_type_id-->tax_type_code + ' (' + tax_type_name + ')', core.accounts.account_id-->account_code + ' (' + account_name + ')'"
         />
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="BottomScriptContentPlaceHolder" runat="server">
</asp:Content>
