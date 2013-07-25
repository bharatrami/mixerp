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
<%@ Page Title="" Language="C#" MasterPageFile="~/ContentMaster.Master" AutoEventWireup="true" CodeBehind="Offices.aspx.cs" Inherits="MixERP.net.FrontEnd.Setup.Offices" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ScriptContentPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="StyleSheetContentPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="BodyContentPlaceHolder" runat="server">
    <pes:Form ID="OfficeForm" runat="server" 
        DenyAdd="false" DenyDelete="true" DenyEdit="true" 
        KeyColumn="office_id" 
        PageSize="10" 
        TableSchema="office" Table="offices" 
        ViewSchema="office" View="offices" 
        Text="Office Setup" 
        DisplayFields="office.offices.office_id-->office_name, core.currencies.currency_code-->currency_symbol + ' (' + currency_code + '/' + currency_name + ')'"
        Width="4000" />
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="BottomScriptContentPlaceHolder" runat="server">
</asp:Content>
