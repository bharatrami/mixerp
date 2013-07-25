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
<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="FormControl.ascx.cs"
    Inherits="MixERP.net.FrontEnd.UserControls.Forms.FormControl" %>
<asp:ScriptManager ID="ScriptManager1" runat="server" />

<asp:UpdateProgress ID="updProgress" runat="server">
    <ProgressTemplate>
        <div class="ajax-container">
            <img alt="progress" src="/spinner.gif" class="ajax-loader" />
        </div>
    </ProgressTemplate>
</asp:UpdateProgress>

<h1>
    <asp:Label ID="TitleLabel" runat="server" />
</h1>
<hr class="hr" />
<asp:UpdatePanel ID="UpdatePanel1" runat="server" ChildrenAsTriggers="true" UpdateMode="Conditional">
    <Triggers>
        <asp:AsyncPostBackTrigger ControlID="SaveButton" />
        <asp:AsyncPostBackTrigger ControlID="CancelButton" />
        <asp:AsyncPostBackTrigger ControlID="EditLinkButton2" />
        <asp:AsyncPostBackTrigger ControlID="DeleteLinkButton2" />
        <asp:AsyncPostBackTrigger ControlID="EditLinkButton" />
        <asp:AsyncPostBackTrigger ControlID="DeleteLinkButton" />
    </Triggers>
    <ContentTemplate>
        <div class="vpad16">
            <a href="#" id="ShowCompactAnchor" class="menu" onclick="window.location = window.location.pathname + '?show=compact';">Show Compact</a>
            <a href="#" id="ShowAllAnchor" class="menu" onclick="window.location = window.location.pathname + '?show=all';">Show All</a>
            <a href="#" id="AddAnchor" class="menu" onclick="$('#FormGridView tr').find('td input:radio').removeAttr('checked');$('#form1').each(function(){this.reset();});$('#GridPanel').hide(500);$('#FormPanel').show(500);">
                <asp:Literal ID="AddNewLiteral" runat="server" Text="<%$Resources:Titles, AddNew %>" /></a>
            <asp:LinkButton ID="EditLinkButton" runat="server" Text="<%$Resources:Titles, EditSelected %>" CssClass="menu"
                OnClick="EditLinkButton_Click" OnClientClick="return(confirmAction());" CausesValidation="false" />
            <asp:LinkButton ID="DeleteLinkButton" runat="server" Text="<%$Resources:Titles, DeleteSelected %>" CssClass="menu" CausesValidation="false"
                OnClick="DeleteLinkButton_Click" OnClientClick="return(confirmAction());" />
            <a href="#" id="PrintAnchor" class="menu" onclick="printThis();">
                <asp:Literal ID="PrintLiteral" runat="server" Text="<%$Resources:Titles, Print %>" />
            </a>
        </div>

        <asp:Label ID="FormLabel" runat="server" />

        <asp:Panel ID="GridPanel" runat="server" ScrollBars="Auto" Width="600">
            <asp:GridView ID="FormGridView" runat="server" AutoGenerateColumns="true" OnRowDataBound="FormGridView_RowDataBound">
                <Columns>
                    <asp:TemplateField HeaderText="<%$Resources:Titles, Select %>" ItemStyle-Width="20px">
                        <HeaderTemplate>
                            <asp:Literal ID="SelectLiteral" runat="server" Text="<%$Resources:Titles, Select %>" />
                        </HeaderTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
            <webdiyer:AspNetPager ID="Pager" runat="server" CssClass="pager" UrlPaging="True"
                PagingButtonType="Text" NumericButtonType="Text" NavigationButtonType="Text"
                ShowNavigationToolTip="true" ShowPageIndexBox="Never" ShowPageIndex="true" AlwaysShowFirstLastPageNumber="true"
                AlwaysShow="false" UrlPageIndexName="page">
            </webdiyer:AspNetPager>
        </asp:Panel>

        <br />

        <asp:Panel ID="FormPanel" runat="server" Style="display: none;">
            <div class="form">
                <h3>
                    <asp:Literal ID="AddNewEntryLiteral" runat="server" Text="<%$Resources:Titles, AddNewEntry %>" />
                </h3>
                <hr class="hr" />
                <p class="info" style="text-align: left; font-weight: bold;">
                    <asp:Literal ID="RequiredFieldDetailsLiteral" runat="server" Text="<%$Resources:Labels, RequiredFieldDetails %>" />
                </p>
                <asp:Panel ID="FormContainer" runat="server">
                </asp:Panel>

                <table>
                    <tr>
                        <td class="label-cell">
                        </td>
                        <td>
                            <asp:Button ID="SaveButton" runat="server" Text="<%$Resources:Titles, Save %>" OnClientClick="adjustSpinnerSize();" OnClick="SaveButton_Click" />
                            <asp:Button ID="CancelButton" runat="server" Text="<%$Resources:Titles, Cancel %>" CausesValidation="false" OnClientClick="$('#FormPanel').hide(500); $('#GridPanel').show(500);" OnClick="CancelButton_Click" />
                            <input type="reset" value="<%$Resources:Titles, Reset %>" runat="server" />
                        </td>
                    </tr>
                </table>
            </div>
            <p class="vpad8"></p>
        </asp:Panel>



        <p>
            <asp:LinkButton ID="ShowCompact2" runat="server" Text="<%$Resources:Titles, ShowCompact %>" CssClass="menu"
                OnClientClick="window.location = window.location.pathname + '?show=compact';" />
            <asp:LinkButton ID="ShowAll2" runat="server" Text="<%$Resources:Titles, ShowAll %>" CssClass="menu" OnClientClick="window.location = window.location.pathname + '?show=all';" />
            <a href="#" id="AddAnchor" class="menu" onclick="$('#FormGridView tr').find('td input:radio').removeAttr('checked');$('#form1').each(function(){this.reset();});$('#GridPanel').hide(500);$('#FormPanel').show(500);">
                <asp:Literal ID="AddNewLiteral2" runat="server" Text="<%$Resources:Titles, AddNew %>" />
            </a>
            <asp:LinkButton ID="EditLinkButton2" runat="server" Text="<%$Resources:Titles, EditSelected %>" CssClass="menu"
                OnClick="EditLinkButton_Click" OnClientClick="return(confirmAction());" CausesValidation="false" />
            <asp:LinkButton ID="DeleteLinkButton2" runat="server" Text="<%$Resources:Titles, DeleteSelected %>" CssClass="menu" CausesValidation="false"
                OnClick="DeleteLinkButton_Click" OnClientClick="return(confirmAction());" />
            <a href="#" id="PrintAnchor2" class="menu" onclick="printThis();">
                <asp:Literal ID="PrintLiteral2" runat="server" Text="<%$Resources:Titles, Print %>" />
            </a>
        </p>
        <p class="vpad16">
        </p>

        <asp:HiddenField ID="UserIdHidden" runat="server" />
        <asp:HiddenField ID="OfficeCodeHidden" runat="server" />
    </ContentTemplate>
</asp:UpdatePanel>

<script type="text/javascript">

    var confirmAction = function () {
        var c = confirm("<%= Resources.Questions.AreYouSure %>");

        if (c) {
            var selected = this.selectedValue();

            if (selected == undefined) {
                alert("<%= Resources.Labels.NothingSelected %>");
                return false;
            }
            return true;
        }
        else {
            return false;
        }
    }

    var selectedValue = function () {
        return $('[id^="SelectRadio"]:checked').val();
    }

    var selected = function (id) {
        $('[id^="SelectRadio"]').removeAttr("checked");

        $("#" + id).attr("checked", "checked");
    }



    var printThis = function () {

        // Assign handlers immediately after making the request,
        // and remember the jqxhr object for this request

        var jqxhr = $.get("/Templates/Print.html", function () {
        })
        .done(function (data) {
            var table = $("#FormGridView").clone();

            var user = $("#UserIdHidden").val();
            var office = $("#OfficeCodeHidden").val();
            var date = '<%= System.DateTime.Now.ToString() %>';

            $(table).find("tr.tableFloatingHeader").remove();

            $(table).find("th:first").remove();
            $(table).find("td:first-child").remove();

            table = "<table border='1' class='preview'>" + table.html() + "</table>";

            data = data.replace("{ReportHeading}", $("#TitleLabel").html());
            data = data.replace("{PrintDate}", date);
            data = data.replace("{UserName}", user);
            data = data.replace("{OfficeCode}", office);
            data = data.replace("{Table}", table);

            var w = window.open();
            w.moveTo(0, 0);
            w.resizeTo(screen.width, screen.height);

            w.document.writeln(data);

        });
    }


    function pageLoad(sender, args) {
        var gridPanel = $('#GridPanel');
        gridPanel.width($(window).width() - 364);

        $('#FormGridView tr').click(function () {
            var radio = $(this).find('td input:radio')
            console.log(radio.prop('id'));
            radio.prop('checked', true);
            selected(radio.attr("id"));
        })

        this.adjustSpinnerSize();
    }

    function adjustSpinnerSize() {
        $(".ajax-container").height($(document).height());
    }





    function UpdateTableHeaders() {
        $("div.floating-header").each(function () {
            var originalHeaderRow = $(".tableFloatingHeaderOriginal", this);
            var floatingHeaderRow = $(".tableFloatingHeader", this);
            var offset = $(this).offset();
            var scrollTop = $(window).scrollTop();
            if ((scrollTop > offset.top) && (scrollTop < offset.top + $(this).height())) {
                floatingHeaderRow.css("visibility", "visible");
                floatingHeaderRow.css("top", Math.min(scrollTop - offset.top, $(this).height() - floatingHeaderRow.height()) + "px");

                // Copy cell widths from original header
                $("th", floatingHeaderRow).each(function (index) {
                    var cellWidth = $("th", originalHeaderRow).eq(index).css('width');
                    $(this).css('width', cellWidth);
                });

                // Copy row width from whole table
                floatingHeaderRow.css("width", $("table.grid").css("width"));
            }
            else {
                floatingHeaderRow.css("visibility", "hidden");
                floatingHeaderRow.css("top", "0px");
            }
        });
    }

    $(document).ready(function () {
        $("table.grid").each(function () {
            $(this).wrap("<div class=\"floating-header\" style=\"position:relative\"></div>");

            var originalHeaderRow = $("tr:first", this)
            originalHeaderRow.before(originalHeaderRow.clone());
            var clonedHeaderRow = $("tr:first", this)

            clonedHeaderRow.addClass("tableFloatingHeader");
            clonedHeaderRow.css("position", "absolute");
            clonedHeaderRow.css("top", "0px");
            clonedHeaderRow.css("left", $(this).css("margin-left"));
            clonedHeaderRow.css("visibility", "hidden");

            originalHeaderRow.addClass("tableFloatingHeaderOriginal");
        });
        UpdateTableHeaders();
        $(window).scroll(UpdateTableHeaders);
        $(window).resize(UpdateTableHeaders);
    });
</script>
