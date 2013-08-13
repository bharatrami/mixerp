<%-- 
Copyright (C) Binod Nepal, Mix Open Foundation (http://mixof.org).

This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. 
If a copy of the MPL was not distributed  with this file, You can obtain one at 
http://mozilla.org/MPL/2.0/.
--%>

<%@ Page Title="" Language="C#" MasterPageFile="~/ContentMaster.Master" AutoEventWireup="true" CodeBehind="Delivery.aspx.cs" Inherits="MixERP.Net.FrontEnd.Sales.Delivery" EnableViewState="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ScriptContentPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="StyleSheetContentPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="BodyContentPlaceHolder" runat="server">
    <h3>Filter</h3>

    <div class="vpad12">
        <table class="valignmiddle">
            <tr>
                <td>
                    <asp:DropDownList ID="FilterDropDownList" runat="server" Width="172" DataTextField="column_name" DataValueField="column_name">
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

    <asp:Panel ID="GridPanel" runat="server" ScrollBars="Auto" Width="600">
        <asp:GridView ID="SearchGridView" runat="server"
            GridLines="None"
            Width="800"
            CssClass="grid"
            PagerStyle-CssClass="gridpager"
            RowStyle-CssClass="row"
            AlternatingRowStyle-CssClass="alt"
            AutoGenerateColumns="true">
            <Columns>
                <asp:TemplateField HeaderText="<%$Resources:Titles, Select %>" ItemStyle-Width="40px">
                    <HeaderTemplate>
                        <asp:Literal ID="SelectLiteral" runat="server" Text="<%$Resources:Titles, Select %>" />
                    </HeaderTemplate>
                    <ItemTemplate>
                        <a href="#" class="linkbutton">
                            <asp:Literal ID="SelectLiteral2" runat="server" Text="<%$Resources:Titles, Select %>" /></a>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </asp:Panel>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="BottomScriptContentPlaceHolder" runat="server">
</asp:Content>