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

<%@ Page Title="" Language="C#" MasterPageFile="~/ContentMaster.Master" AutoEventWireup="true" CodeBehind="Items.aspx.cs" Inherits="MixERP.Net.FrontEnd.Items.Setup.Items" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ScriptContentPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="StyleSheetContentPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="BodyContentPlaceHolder" runat="server">
    <pes:Form ID="ItemForm" runat="server" Text="Item Maintenance" TableSchema="core" Table="items" KeyColumn="item_id"
        ViewSchema="core" View="items" Width="2000" PageSize="10"
        SelectedValues=""
        DisplayFields="core.item_groups.item_group_id-->item_group_code + ' (' + item_group_name + ')', core.brands.brand_id-->brand_code + ' (' + brand_name + ')', core.suppliers.supplier_id-->supplier_code + ' (' + company_name + ')', core.units.unit_id-->unit_code + ' (' + unit_name + ')', core.taxes.tax_id-->tax_code + ' (' + tax_name + ')'" />
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="BottomScriptContentPlaceHolder" runat="server">
</asp:Content>
