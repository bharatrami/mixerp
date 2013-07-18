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
<%@ Page Title="" Language="C#" MasterPageFile="~/ContentMaster.Master" AutoEventWireup="true" CodeBehind="TaxFormDetails.aspx.cs" Inherits="MixERP.net.FrontEnd.Finance.Setup.TaxFormDetails" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ScriptContentPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="StyleSheetContentPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="BodyContentPlaceHolder" runat="server">
    <pes:Form ID="TaxFormDetailForm" runat="server" Text="Tax Form Details" TableSchema="core" Table="tax_form_details" KeyColumn="tax_form_detail_id"
        ViewSchema="core" View="tax_form_detail_view" Width="1000" PageSize="10" 
        SelectedValues=""
        DisplayFields="core.tax_forms.tax_form_id-->tax_form_code + ' (' + tax_form_name + ')', core.taxes.tax_id-->tax_code + ' (' + tax_name + ')'" />
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="BottomScriptContentPlaceHolder" runat="server">
</asp:Content>
