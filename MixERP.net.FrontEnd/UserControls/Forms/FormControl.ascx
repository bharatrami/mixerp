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
            <a href="#" id="AddAnchor" class="menu" onclick="$('#form1').each(function(){this.reset();});$('#GridPanel').hide(500);$('#FormPanel').show(500);">Add New</a>
            <asp:LinkButton ID="EditLinkButton" runat="server" Text="Edit Selected" CssClass="menu"
                OnClick="EditLinkButton_Click" OnClientClick="return(confirmAction());" CausesValidation="false" />
            <asp:LinkButton ID="DeleteLinkButton" runat="server" Text="Delete Selected" CssClass="menu" CausesValidation="false"
                OnClick="DeleteLinkButton_Click" OnClientClick="return(confirmAction());" />
            <a href="#" id="PrintAnchor" class="menu" onclick="printThis();">
                Print</a>
        </div>


        <asp:Literal ID="FormLiteral" runat="server" />

        <asp:Panel ID="GridPanel" runat="server" ScrollBars="Auto" Width="600">
            <asp:GridView ID="FormGridView" runat="server" AutoGenerateColumns="true" OnRowDataBound="FormGridView_RowDataBound">
                <Columns>
                    <asp:TemplateField HeaderText="Select" ItemStyle-Width="20px">
                        <HeaderTemplate>
                            Select
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
                    Add a New Entry
                </h3>
                <hr class="hr" />
                <p class="info" style="text-align: left; font-weight: bold;">
                    The fields marked with asterisk (*) are required.
                </p>
                <asp:Panel ID="FormContainer" runat="server">
                </asp:Panel>

                <table>
                    <tr>
                        <td class="label-cell">
                        </td>
                        <td>
                            <asp:Button ID="SaveButton" runat="server" Text="Save" OnClick="SaveButton_Click" />
                            <asp:Button ID="CancelButton" runat="server" Text="Cancel" CausesValidation="false" OnClientClick="$('#FormPanel').hide(500); $('#GridPanel').show(500);" OnClick="CancelButton_Click" />
                            <input type="reset" value="Reset" runat="server" />
                        </td>
                    </tr>
                </table>
            </div>
            <p class="vpad8"></p>
        </asp:Panel>



        <p>
            <asp:LinkButton ID="ShowCompact2" runat="server" Text="Show Compact" CssClass="menu"
                OnClientClick="window.location = window.location.pathname + '?show=compact';" />
            <asp:LinkButton ID="ShowAll2" runat="server" Text="Show All" CssClass="menu" OnClientClick="window.location = window.location.pathname + '?show=all';" />
            <a href="#" id="AddAnchor" class="menu" onclick="$('#form1').each(function(){this.reset();});$('#GridPanel').hide(500);$('#FormPanel').show(500);">
                Add New
            </a>
            <asp:LinkButton ID="EditLinkButton2" runat="server" Text="Edit Selected" CssClass="menu"
                OnClick="EditLinkButton_Click" OnClientClick="return(confirmAction());" CausesValidation="false" />
            <asp:LinkButton ID="DeleteLinkButton2" runat="server" Text="Delete Selected" CssClass="menu" CausesValidation="false"
                OnClick="DeleteLinkButton_Click" OnClientClick="return(confirmAction());" />
            <a href="#" id="PrintAnchor2" class="menu" onclick="printThis();">
                Print</a>
        </p>
        <p class="vpad16">
        </p>

        <asp:HiddenField ID="UserIdHidden" runat="server" />
        <asp:HiddenField ID="OfficeCodeHidden" runat="server" />
    </ContentTemplate>
</asp:UpdatePanel>

<script type="text/javascript">

    var confirmAction = function () {
        var c = confirm('Are you sure?');

        if (c) {
            var selected = this.selectedValue();

            if (selected == undefined) {
                alert('Nothing selected!');
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

                jQuery(document).ready(function () {
                    $(".ajax-container").height($(document).height() + 100);
                }
            );
            }
</script>
