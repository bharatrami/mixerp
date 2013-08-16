<%-- 
Copyright (C) Binod Nepal, Mix Open Foundation (http://mixof.org).

This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. 
If a copy of the MPL was not distributed  with this file, You can obtain one at 
http://mozilla.org/MPL/2.0/.
--%>
<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="FormControl.ascx.cs"
    Inherits="MixERP.Net.FrontEnd.UserControls.Forms.FormControl" %>
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

<asp:Label ID="DescriptionLabel" runat="server" />

<asp:UpdatePanel ID="UpdatePanel1" runat="server" ChildrenAsTriggers="true" UpdateMode="Conditional">
    <Triggers>
        <asp:AsyncPostBackTrigger ControlID="SaveButton" />
        <asp:AsyncPostBackTrigger ControlID="CancelButton" />
        <asp:AsyncPostBackTrigger ControlID="EditButton2" />
        <asp:AsyncPostBackTrigger ControlID="DeleteButton2" />
        <asp:AsyncPostBackTrigger ControlID="EditButton" />
        <asp:AsyncPostBackTrigger ControlID="DeleteButton" />
    </Triggers>
    <ContentTemplate>
        <div class="vpad16">
            <asp:Button ID="ShowCompactButton" runat="server"
                CssClass="menu"
                Text="<%$Resources:Titles, ShowCompact %>"
                ToolTip="Alt + C"
                OnClientClick="showCompact();"
                CausesValidation="false" />

            <asp:Button ID="ShowAllButton" runat="server"
                CssClass="menu"
                Text="<%$Resources:Titles, ShowAll %>"
                ToolTip="Ctrl + S"
                OnClientClick="showAll"
                CausesValidation="false" />

            <asp:Button ID="AddButton" runat="server"
                CssClass="menu"
                Text="<%$Resources:Titles, AddNew %>"
                ToolTip="Alt + A"
                OnClientClick="return(addNew());"
                CausesValidation="false" />

            <asp:Button ID="EditButton" runat="server"
                CssClass="menu"
                Text="<%$Resources:Titles, EditSelected %>"
                OnClick="EditButton_Click"
                ToolTip="Ctrl + E"
                OnClientClick="return(confirmAction());"
                CausesValidation="false" />

            <asp:Button ID="DeleteButton" runat="server"
                Text="<%$Resources:Titles, DeleteSelected %>"
                CssClass="menu"
                ToolTip="Ctrl + D"
                OnClick="DeleteButton_Click"
                OnClientClick="return(confirmAction());"
                CausesValidation="false" />

            <asp:Button ID="PrintButton" runat="server"
                Text="<%$Resources:Titles, Print %>"
                CssClass="menu"
                ToolTip="Ctrl + P"
                OnClientClick="printThis();"
                CausesValidation="false" />
        </div>

        <asp:Label ID="FormLabel" runat="server" />

        <asp:Panel ID="GridPanel" runat="server" ScrollBars="Auto" Width="1000">
            <asp:GridView ID="FormGridView"
                runat="server"
                GridLines="None"
                CssClass="grid"
                PagerStyle-CssClass="gridpager"
                RowStyle-CssClass="row"
                AlternatingRowStyle-CssClass="alt"
                AutoGenerateColumns="true"
                OnRowDataBound="FormGridView_RowDataBound">
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
                            <asp:Button ID="SaveButton" runat="server" Text="<%$Resources:Titles, Save %>" OnClientClick="adjustSpinnerSize();" OnClick="SaveButton_Click" CssClass="button" />
                            <asp:Button ID="CancelButton" runat="server" Text="<%$Resources:Titles, Cancel %>" CausesValidation="false" OnClientClick="$('#FormPanel').hide(500); $('#GridPanel').show(500);" OnClick="CancelButton_Click" CssClass="button" />
                            <input type="reset" value="<%$Resources:Titles, Reset %>" runat="server" class="button" />
                        </td>
                    </tr>
                </table>
            </div>
            <p class="vpad8"></p>
        </asp:Panel>



        <p>
            <asp:Button ID="ShowCompactButton2" runat="server"
                CssClass="menu"
                Text="<%$Resources:Titles, ShowCompact %>"
                ToolTip="Alt + C"
                OnClientClick="showCompact();"
                CausesValidation="false" />

            <asp:Button ID="ShowAllButton2" runat="server"
                CssClass="menu"
                Text="<%$Resources:Titles, ShowAll %>"
                ToolTip="Ctrl + S"
                OnClientClick="showAll();"
                CausesValidation="false" />

            <asp:Button ID="AddButton2" runat="server"
                CssClass="menu"
                Text="<%$Resources:Titles, AddNew %>"
                ToolTip="Alt + A"
                OnClientClick="return(addNew());"
                CausesValidation="false" />

            <asp:Button ID="EditButton2" runat="server"
                CssClass="menu"
                Text="<%$Resources:Titles, EditSelected %>"
                ToolTip="Ctrl + E"
                OnClick="EditButton_Click"
                OnClientClick="return(confirmAction());"
                CausesValidation="false" />

            <asp:Button ID="DeleteButton2" runat="server"
                Text="<%$Resources:Titles, DeleteSelected %>"
                CssClass="menu"
                ToolTip="Ctrl + D"
                OnClick="DeleteButton_Click"
                OnClientClick="return(confirmAction());"
                CausesValidation="false" />

            <asp:Button ID="PrintButton2" runat="server"
                Text="<%$Resources:Titles, Print %>"
                CssClass="menu"
                ToolTip="Ctrl + P"
                OnClientClick="printThis();"
                CausesValidation="false" />

        </p>
        <p class="vpad16">
        </p>

        <asp:HiddenField ID="UserIdHidden" runat="server" />
        <asp:HiddenField ID="OfficeCodeHidden" runat="server" />
    </ContentTemplate>
</asp:UpdatePanel>

<script type="text/javascript">

    var showCompact = function () {
        window.location = window.location.pathname + '?show=compact';
    }

    var showAll = function () {
        window.location = window.location.pathname + '?show=all';
    }

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
        var randomnumber = Math.floor(Math.random() * 1200)

        //Append the report template with a random number to prevent caching.
        var reportTemplatePath = "/Reports/Print.html?" + randomnumber;

        var report = $.get(reportTemplatePath, function () { }).done(function (data) {
            var report = $.get("/Reports/Assets/Header.aspx", function () { }).done(function (header) {
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
                data = data.replace("{Header}", header);
                var w = window.open();
                w.moveTo(0, 0);
                w.resizeTo(screen.width, screen.height);

                w.document.writeln(data);

            });
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

    var addNew = function () {
        $('#FormGridView tr').find('td input:radio').removeAttr('checked');
        $('#form1').each(function () {
            this.reset();
        });

        $('#GridPanel').hide(500);
        $('#FormPanel').show(500);

        //Prevent postback
        return false;
    }

    $(document).ready(function () {
        shortcut.add("ESC", function () {
            if (!$('#FormPanel').is(':hidden')) {

                if ($("#colorbox").css("display") != "block") {
                    var result = confirm('Are you sure?');
                    if (result) {
                        $('#CancelButton').click();
                    }
                }
            }
        });

        shortcut.add("ALT+C", function () {
            $('#ShowCompactButton').click();
        });

        shortcut.add("CTRL+S", function () {
            $('#ShowAllButton').click();
        });

        shortcut.add("ALT+A", function () {
            $('#AddButton').click();
        });

        shortcut.add("CTRL+E", function () {
            $('#EditButton').click();
        });

        shortcut.add("CTRL+D", function () {
            $('#DeleteButton').click();
        });

        shortcut.add("CTRL+P", function () {
            printThis();
        });

    });


</script>
