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
<%@ Page Title="" Language="C#" MasterPageFile="~/ContentMaster.Master" AutoEventWireup="true" CodeBehind="BonusSlabAssignment.aspx.cs" Inherits="MixERP.net.FrontEnd.Sales.Setup.BonusSlabAssignment" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ScriptContentPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="StyleSheetContentPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="BodyContentPlaceHolder" runat="server">
    <pes:Form ID="BonusSetupForm" runat="server" DenyAdd="false" DenyDelete="false" DenyEdit="false" KeyColumn="agent_bonus_setup_id"
        PageSize="10" TableSchema="core" Table="agent_bonus_setups" ViewSchema="core" View="agent_bonus_setup_view" Text="Agent Bonus Slab Assignment" Width="1000"
        DisplayFields="core.bonus_slabs.bonus_slab_id-->bonus_slab_name, core.agents.agent_id-->agent_name"
         />
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="BottomScriptContentPlaceHolder" runat="server">
</asp:Content>
