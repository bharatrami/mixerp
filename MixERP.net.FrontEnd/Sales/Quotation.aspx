<%-- 
Copyright (C) Binod Nepal, Mix Open Foundation (http://mixof.org).

This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. 
If a copy of the MPL was not distributed  with this file, You can obtain one at 
http://mozilla.org/MPL/2.0/.
--%>

<%@ Page Title="" Language="C#" MasterPageFile="~/ContentMaster.Master" AutoEventWireup="true" CodeBehind="Quotation.aspx.cs" Inherits="MixERP.Net.FrontEnd.Sales.Quotation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ScriptContentPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="StyleSheetContentPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="BodyContentPlaceHolder" runat="server">
    <h1>
        <asp:Literal ID="TitleLiteral" runat="server" Text="<%$Resources:Titles, SalesQuotation %>" />
    </h1>
    <hr class="hr" />

    <div class="vpad12">
        <asp:LinkButton ID="AddNewLinkButton" runat="server" CssClass="menu" Text="<%$Resources:Titles, AddNew %>"
            OnClientClick="window.location='/Sales/Entry/Quotation.aspx';return false;" />
        <asp:LinkButton ID="FlagLinkButton" runat="server" CssClass="menu" Text="<%$Resources:Titles, FlagSelection %>" />
        <asp:LinkButton ID="MergeToSalesOrderLinkButton" runat="server" CssClass="menu" Text="<%$Resources:Titles, MergeBatchToSalesOrder %>" />
    </div>

    <asp:GridView
        ID="SalesQuotationGridView"
        runat="server"
        CssClass="grid"
        Width="100%"
        AutoGenerateColumns="false"
        OnRowDataBound="SalesQuotationGridView_RowDataBound">
        <Columns>
            <asp:TemplateField>
                <ItemTemplate>
                    <a href="#" title="Preview">
                        <img src="../Resource/Icons/search-16.png" />
                    </a>
                    <a href="#" title="Go To Top">
                        <img src="../Resource/Icons/top-16.png" />
                    </a>
                    <a href="#">

                    </a>
                    <a href="#">

                    </a>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField>
                <ItemTemplate>
                    <input type="checkbox" />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="id" HeaderText="id" />
            <asp:BoundField DataField="value_date" HeaderText="value_date" DataFormatString="dd/mm/yyyy" />
            <asp:BoundField DataField="office" HeaderText="office" />
            <asp:BoundField DataField="party" HeaderText="party" />
            <asp:BoundField DataField="price_type" HeaderText="price_type" />
            <asp:BoundField DataField="transaction_ts" HeaderText="transaction_ts" />
            <asp:BoundField DataField="user" HeaderText="user" />
            <asp:BoundField DataField="reference_number" HeaderText="reference_number" />
            <asp:BoundField DataField="statement_reference" HeaderText="statement_reference" />
        </Columns>
    </asp:GridView>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="BottomScriptContentPlaceHolder" runat="server">
</asp:Content>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        using(System.Data.DataTable table = MixERP.Net.BusinessLayer.Transactions.NonGlStockTransaction.GetView("Sales.Quotation"))
        {
            SalesQuotationGridView.DataSource = table;
            SalesQuotationGridView.DataBind();
        }
    }

    protected void SalesQuotationGridView_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if(e.Row.RowType == DataControlRowType.Header)
        {
            for(int i = 0; i < e.Row.Cells.Count; i++)
            {
                string cellText = e.Row.Cells[i].Text.Replace("&nbsp;", " ").Trim();

                if(!string.IsNullOrWhiteSpace(cellText))
                {
                    cellText = Pes.Utility.Helpers.LocalizationHelper.GetResourceString("FormResource", cellText);
                    e.Row.Cells[i].Text = cellText;
                }
            }
        }
    }

    
</script>
