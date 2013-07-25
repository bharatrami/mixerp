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
<%@ Page Title="" Language="C#" MasterPageFile="~/ContentMaster.Master" AutoEventWireup="true" CodeBehind="SellingPrices.aspx.cs" Inherits="MixERP.net.FrontEnd.Items.Setup.SellingPrices" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ScriptContentPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="StyleSheetContentPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="BodyContentPlaceHolder" runat="server">
    <pes:Form ID="ItemSellingPriceForm" runat="server" Text="Item Selling Price Maintenance" TableSchema="core" Table="item_selling_prices" KeyColumn="item_selling_price_id"
        ViewSchema="core" View="item_selling_price_view" Width="1000" PageSize="10"
        SelectedValues=""
        DisplayFields="core.items.item_id-->item_code + ' (' + item_name + ')', core.customer_types.customer_type_id-->customer_type_code + ' (' + customer_type_name + ')', core.price_types.price_type_id-->price_type_code + ' (' + price_type_name + ')', core.units.unit_id-->unit_code + ' (' + unit_name + ')' " />
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="BottomScriptContentPlaceHolder" runat="server">
</asp:Content>
