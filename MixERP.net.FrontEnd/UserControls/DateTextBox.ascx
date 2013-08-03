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
<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="DateTextBox.ascx.cs" Inherits="MixERP.Net.FrontEnd.UserControls.DateTextBox" %>
<asp:TextBox ID="TextBox1" runat="server" Width="100">
</asp:TextBox>
<ajaxToolkit:CalendarExtender ID="CalendarExtender1" runat="server" />
<br />
<asp:CompareValidator ID="CompareValidator1" runat="server" Display="Dynamic" />

