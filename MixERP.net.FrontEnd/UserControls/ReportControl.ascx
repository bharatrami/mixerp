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
<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ReportControl.ascx.cs" Inherits="MixERP.Net.FrontEnd.UserControls.ReportControl" %>
<asp:HiddenField ID="ReportHidden" runat="server" />
<asp:HiddenField ID="ReportTitleHidden" runat="server" />

<div class="report-command hide">
    <asp:ImageButton ID="SendEmailImageButton" runat="server" ImageUrl="~/Resource/Icons/email-16.png" />
    <a href="javascript:window.print();">
        <img src="/Resource/Icons/print-16.png" />
    </a>
    <asp:ImageButton ID="ExcelImageButton" runat="server" ImageUrl="~/Resource/Icons/excel-16.png" OnClientClick="$('#ReportHidden').val(getPageHTML())" OnClick="ExcelImageButton_Click" />

    <a href="javascript:window.scrollTo(0, 0);">
        <img src="/Resource/Icons/top-16.png" />
    </a>
    <a href="javascript:window.scrollTo(0,document.body.scrollHeight);">
        <img src="/Resource/Icons/bottom-16.png" />
    </a>
    <a onclick="$('.report-parameter').toggle(500);" href="#">
        <img src="/Resource/Icons/filter-16.png" />
    </a>
</div>

<div id="report">
    <pes:ReportHeader runat="server" />

    <h1>
        <asp:Literal ID="ReportTitleLiteral" runat="server" />
    </h1>
    <div>
        <asp:Literal ID="TopSectionLiteral" runat="server" />


        <asp:PlaceHolder ID="BodyPlaceHolder" runat="server">
            <asp:Literal ID="ContentLiteral" runat="server"></asp:Literal>
        </asp:PlaceHolder>
        <asp:Literal ID="BottomSectionLiteral" runat="server" />
    </div>
</div>

<script type="text/javascript">
    function getPageHTML() {
      return "<html>" + $("#report").html() + "</html>";
    }
</script>
