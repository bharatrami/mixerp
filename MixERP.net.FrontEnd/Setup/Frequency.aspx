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
<%@ Page Title="" Language="C#" MasterPageFile="~/ContentMaster.Master" AutoEventWireup="true" CodeBehind="Frequency.aspx.cs" Inherits="MixERP.net.FrontEnd.Setup.Frequency" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ScriptContentPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="StyleSheetContentPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="BodyContentPlaceHolder" runat="server">
    <pes:Form ID="FrequencySetupForm" runat="server" DenyAdd="false" DenyDelete="false" DenyEdit="false" KeyColumn="frequency_setup_id"
        PageSize="10" TableSchema="core" Table="frequency_setups" ViewSchema="core" View="frequency_setups" Text="Frequency Setup" Width="1000"
        DisplayFields="core.frequencies.frequency_id-->frequency_name, core.fiscal_year.fiscal_year_code-->fiscal_year_code + ' (' + fiscal_year_name + ')'" />
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="BottomScriptContentPlaceHolder" runat="server">
</asp:Content>
