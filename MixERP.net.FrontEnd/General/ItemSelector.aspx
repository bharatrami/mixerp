<%-- 
Copyright (C) Binod Nepal, Mix Open Foundation (http://mixof.org).

This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. 
If a copy of the MPL was not distributed  with this file, You can obtain one at 
http://mozilla.org/MPL/2.0/.
--%>

<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ItemSelector.aspx.cs" Inherits="MixERP.Net.FrontEnd.General.ItemSelector" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="~/themes/purple/main.css" rel="stylesheet" type="text/css" runat="server" />
    <script src="/Scripts/jquery.min.js" type="text/javascript"></script>
    <style type="text/css">
        html, body, form
        {
            height: 100%;
        }

        form
        {
            background-color: white!important;
            padding:12px;
        }

        .grid td, .grid th
        {
            white-space: nowrap;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <h3>Quick View</h3>

        <div class="vpad12">
            <table class="valignmiddle">
                <tr>
                    <td>
                        <asp:DropDownList ID="FilterDropDownList" runat="server" Width="172"
                            DataTextField="column_name" DataValueField="column_name"
                            OnDataBound="FilterDropDownList_DataBound">
                        </asp:DropDownList>
                    </td>
                    <td>
                        <asp:TextBox ID="FilterTextBox" runat="server">
                        </asp:TextBox>
                    </td>
                    <td>
                        <asp:Button ID="GoButton" runat="server" CssClass="button" Text="<%$Resources:Titles, Go %>" Height="25" OnClick="GoButton_Click" />
                    </td>
                </tr>
            </table>
        </div>

        <asp:Panel ID="GridPanel" runat="server" ScrollBars="Auto" Width="900">
            <asp:GridView ID="SearchGridView" runat="server"
                GridLines="None"
                CssClass="grid"
                PagerStyle-CssClass="gridpager"
                RowStyle-CssClass="row"
                AlternatingRowStyle-CssClass="alt"
                AutoGenerateColumns="true"
                OnRowDataBound="SearchGridView_RowDataBound">
                <Columns>
                    <asp:TemplateField HeaderText="<%$Resources:Titles, Select %>">
                        <HeaderTemplate>
                            <asp:Literal ID="SelectLiteral" runat="server" Text="<%$Resources:Titles, Select %>" />
                        </HeaderTemplate>
                        <ItemTemplate>
                            <a href="#" class="linkbutton" onclick='updateValue("<%# (Container.DataItem as System.Data.DataRowView)[0].ToString() %>");'>
                                <asp:Literal ID="SelectLiteral2" runat="server" Text="<%$Resources:Titles, Select %>" /></a>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </asp:Panel>
    </div>

        <script type="text/javascript">
            function getParameterByName(name) {
                name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
                var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
                    results = regex.exec(location.search);
                return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
            }

            function updateValue(val) {
                var ctl = getParameterByName('AssociatedControlId');
                $('#' + ctl, parent.document.body).val(val);
                parent.jQuery.colorbox.close();
            }
        </script>
            <script type="text/javascript">
                document.onkeydown = function (evt) {
                    evt = evt || window.event;
                    if (evt.keyCode == 27) {
                        top.close();
                    }
                };
    </script>
    </form>
</body>
</html>


<script runat="server">
    protected void FilterDropDownList_DataBound(object sender, EventArgs e)
    {
        foreach(ListItem item in FilterDropDownList.Items)
        {
            item.Text = Pes.Utility.Helpers.LocalizationHelper.GetResourceString("FormResource", item.Text);
        }
    }

    protected void SearchGridView_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if(e.Row.RowType == DataControlRowType.Header)
        {
            for(int i = 0; i < e.Row.Cells.Count; i++)
            {
                string cellText = e.Row.Cells[i].Text;
                if(!string.IsNullOrWhiteSpace(cellText))
                {
                    cellText = Pes.Utility.Helpers.LocalizationHelper.GetResourceString("FormResource", cellText);
                    e.Row.Cells[i].Text = cellText;
                }
            }
        }
    }

    protected void Page_Init(object sender, EventArgs e)
    {
        this.LoadParmeters();
        this.LoadGridView();
    }

    private string GetSchema()
    {
        return Pes.Utility.Conversion.TryCastString(this.Request["Schema"]);
    }

    private string GetView()
    {
        return Pes.Utility.Conversion.TryCastString(this.Request["View"]);
    }

    protected void GoButton_Click(object sender, EventArgs e)
    {
        if(string.IsNullOrWhiteSpace(this.GetSchema())) return;
        if(string.IsNullOrWhiteSpace(this.GetView())) return;
        
        using(System.Data.DataTable table = MixERP.Net.BusinessLayer.Helpers.FormHelper.GetTable(this.GetSchema(), this.GetView(), FilterDropDownList.SelectedItem.Value, FilterTextBox.Text, 10))
        {
            SearchGridView.DataSource = table;
            SearchGridView.DataBind();
        }
    }

    private void LoadParmeters()
    {
        if(string.IsNullOrWhiteSpace(this.GetSchema())) return;
        if(string.IsNullOrWhiteSpace(this.GetView())) return;

        using(System.Data.DataTable table = MixERP.Net.BusinessLayer.Helpers.TableHelper.GetTable(this.GetSchema(), this.GetView(), ""))
        {
            FilterDropDownList.DataSource = table;
            FilterDropDownList.DataBind();
        }
    }

    private void LoadGridView()
    {
        if(string.IsNullOrWhiteSpace(this.GetSchema())) return;
        if(string.IsNullOrWhiteSpace(this.GetView())) return;

        using(System.Data.DataTable table = MixERP.Net.BusinessLayer.Helpers.FormHelper.GetTable(this.GetSchema(), this.GetView(), "", "", 10))
        {
            SearchGridView.DataSource = table;
            SearchGridView.DataBind();
        }
    }
</script>
