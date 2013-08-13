<%-- 
Copyright (C) Binod Nepal, Mix Open Foundation (http://mixof.org).

This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. 
If a copy of the MPL was not distributed  with this file, You can obtain one at 
http://mozilla.org/MPL/2.0/.
--%>
<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ProductControl.ascx.cs" Inherits="MixERP.Net.FrontEnd.UserControls.Products.ProductControl" %>
<asp:ScriptManager ID="ScriptManager1" runat="server" />

<div style="width: 1000px; overflow: hidden; margin: 0 auto;">
    <asp:Label ID="TitleLabel" CssClass="title" runat="server" />
    <asp:UpdateProgress ID="UpdateProgress1" runat="server">
        <ProgressTemplate>
            <div class="ajax-container">
                <img alt="progress" src="/spinner.gif" class="ajax-loader" />
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>

    <asp:UpdatePanel ID="UpdatePanel1" runat="server" ChildrenAsTriggers="true" UpdateMode="Always">
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="CashRepositoryDropDownList" />
            <asp:AsyncPostBackTrigger ControlID="ProductGridView" />
            <asp:AsyncPostBackTrigger ControlID="AddButton" />
            <asp:AsyncPostBackTrigger ControlID="OKButton" />
            <asp:AsyncPostBackTrigger ControlID="CancelButton" />
            <asp:AsyncPostBackTrigger ControlID="ItemDropDownList" />
            <asp:AsyncPostBackTrigger ControlID="UnitDropDownList" />
            <asp:AsyncPostBackTrigger ControlID="ShippingChargeTextBox" />            
            <asp:PostBackTrigger ControlID="SaveButton" />
        </Triggers>
        <ContentTemplate>
            <asp:HiddenField ID="ModeHiddenField" runat="server" />

            <asp:Panel ID="TopPanel" CssClass="form" runat="server">
                <table class="form-table">
                    <tr>
                        <td>
                            <asp:Literal ID="DateLiteral" runat="server" />
                        </td>
                        <td>
                            <asp:Literal ID="StoreLiteral" runat="server" />
                        </td>
                        <td>
                            <asp:Literal ID="TransactionTypeLiteral" runat="server" />
                        </td>
                        <td>
                            <asp:Literal ID="PartyLiteral" runat="server" />
                        </td>
                        <td>
                            <asp:Literal ID="PriceTypeLiteral" runat="server" />
                        </td>
                        <td>
                        </td>
                    </tr>
                    <tr style="vertical-align: middle;">
                        <td>
                            <mixerp:DateTextBox ID="DateTextBox" runat="server" Width="70" CssClass="date" />
                        </td>
                        <td>
                            <asp:DropDownList ID="StoreDropDownList" runat="server" Width="80">
                            </asp:DropDownList>
                        </td>
                        <td>
                            <asp:RadioButtonList ID="TransactionTypeRadioButtonList" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Text="<%$ Resources:Titles, Cash %>" Value="<%$ Resources:Titles, Cash %>" Selected="True" />
                                <asp:ListItem Text="<%$ Resources:Titles, Credit %>" Value="<%$ Resources:Titles, Credit %>" />
                            </asp:RadioButtonList>
                        </td>
                        <td>
                            <asp:TextBox ID="PartyCodeTextBox" runat="server" Width="80" 
                                onblur="selectItem(this.id, 'PartyDropDownList');" />
                            <asp:DropDownList ID="PartyDropDownList" runat="server" Width="150"
                                   onchange="document.getElementById('PartyCodeTextBox').value = this.options[this.selectedIndex].value;if(this.selectedIndex == 0) { return false };"                                
                                >
                            </asp:DropDownList>
                        </td>
                        <td>
                            <asp:DropDownList ID="PriceTypeDropDownList" runat="server" Width="80">
                            </asp:DropDownList>
                        </td>
                        <td>
                            <asp:Button ID="OKButton" runat="server" Text="<%$ Resources:Titles, OK %>" Width="40" OnClick="OKButton_Click" />
                            <asp:Button ID="CancelButton" runat="server" Text="<%$ Resources:Titles, Cancel %>" Width="50" Enabled="false" OnClick="CancelButton_Click" />
                        </td>
                    </tr>
                </table>
            </asp:Panel>

            <p>
                <asp:Label ID="ErrorLabelTop" runat="server" CssClass="error" />
            </p>
            <div class="center">
                <asp:GridView ID="ProductGridView" runat="server" EnableTheming="False"
                    CssClass="grid2" ShowHeaderWhenEmpty="true"
                    AlternatingRowStyle-CssClass="grid2-row-alt"
                    OnRowDataBound="ProductGridView_RowDataBound"
                    OnRowCommand="ProductGridView_RowCommand"
                    AutoGenerateColumns="False">
                    <Columns>
                        <asp:BoundField DataField="ItemCode" HeaderText="<%$ Resources:Titles, Code %>" HeaderStyle-Width="70" />
                        <asp:BoundField DataField="ItemName" HeaderText="<%$ Resources:Titles, ItemName %>" HeaderStyle-Width="315" />
                        <asp:BoundField DataField="Quantity" HeaderText="<%$ Resources:Titles, QuantityAbbreviated %>" ItemStyle-CssClass="right" HeaderStyle-CssClass="right" HeaderStyle-Width="50" />
                        <asp:BoundField DataField="Unit" HeaderText="<%$ Resources:Titles, Unit %>" HeaderStyle-Width="70" />
                        <asp:BoundField DataField="Price" HeaderText="<%$ Resources:Titles, Price %>" ItemStyle-CssClass="right" HeaderStyle-CssClass="right" HeaderStyle-Width="75" />
                        <asp:BoundField DataField="Amount" HeaderText="<%$ Resources:Titles, Amount %>" ItemStyle-CssClass="right" HeaderStyle-CssClass="right" HeaderStyle-Width="75" />
                        <asp:BoundField DataField="Discount" HeaderText="<%$ Resources:Titles, Discount %>" ItemStyle-CssClass="right" HeaderStyle-CssClass="right" HeaderStyle-Width="50" />
                        <asp:BoundField DataField="SubTotal" HeaderText="<%$ Resources:Titles, SubTotal %>" ItemStyle-CssClass="right" HeaderStyle-CssClass="right" HeaderStyle-Width="75" />
                        <asp:BoundField DataField="Rate" HeaderText="<%$ Resources:Titles, Rate %>" ItemStyle-CssClass="right" HeaderStyle-CssClass="right" HeaderStyle-Width="40" />
                        <asp:BoundField DataField="Tax" HeaderText="<%$ Resources:Titles, Tax %>" ItemStyle-CssClass="right" HeaderStyle-CssClass="right" HeaderStyle-Width="50" />
                        <asp:BoundField DataField="Total" HeaderText="<%$ Resources:Titles, Total %>" ItemStyle-CssClass="right" HeaderStyle-CssClass="right" HeaderStyle-Width="80" />
                        <asp:TemplateField ShowHeader="False" HeaderStyle-Width="50" HeaderText="<%$ Resources:Titles, Action %>">
                            <ItemTemplate>
                                <asp:ImageButton ID="DeleteImageButton" ClientIDMode="Predictable" runat="server"
                                    CausesValidation="false"
                                    OnClientClick="return(confirmAction());"
                                    ImageUrl="~/Resource/Icons/delete-16.png" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <AlternatingRowStyle CssClass="grid2-row-alt" />
                    <FooterStyle CssClass="grid2-footer" />
                    <HeaderStyle CssClass="grid2-header" />
                    <RowStyle CssClass="grid2-row" />
                </asp:GridView>

                <asp:Panel ID="FormPanel" runat="server" Enabled="false">
                    <table id="FormTable" class="grid3" runat="server">
                        <tr>
                            <td>
                                <asp:TextBox ID="ItemCodeTextBox" runat="server" 
                                    onblur="selectItem(this.id, 'ItemDropDownList');" 
                                    ToolTip="Alt + C" Width="58" />
                            </td>
                            <td>
                                <asp:DropDownList ID="ItemDropDownList" runat="server"
                                    onchange="document.getElementById('ItemCodeTextBox').value = this.options[this.selectedIndex].value;if(this.selectedIndex == 0) { return false };"
                                    onblur="getPrice();"
                                    ToolTip="Ctrl + I" Width="300">
                                </asp:DropDownList>
                                <ajaxToolkit:CascadingDropDown ID="ItemDropDownListCascadingDropDown" runat="server"
                                    TargetControlID="ItemDropDownList" Category="Item" 
                                    ServicePath="~/Services/ItemData.asmx"
                                    LoadingText="<%$Resources:Labels, Loading %>"
                                    PromptText="<%$Resources:Titles, Select %>">
                                </ajaxToolkit:CascadingDropDown>
                            </td>
                            <td>
                                <asp:TextBox ID="QuantityTextBox" 
                                    runat="server" type="number" 
                                    onblur="calculateAmount();" CssClass="right"
                                    Text="1"
                                    ToolTip="Ctrl + Q" Width="42" />
                            </td>
                            <td>
                                <asp:DropDownList ID="UnitDropDownList" runat="server" AutoPostBack="true"
                                    ToolTip="Ctrl + U" Width="68">
                                </asp:DropDownList>
                                <ajaxToolkit:CascadingDropDown ID="UnitDropDownListCascadingDropDown" runat="server"
                                    ParentControlID="ItemDropDownList" TargetControlID="UnitDropDownList"
                                    Category="Unit" ServiceMethod="GetUnits"
                                    ServicePath="~/Services/ItemData.asmx"
                                    LoadingText="<%$Resources:Labels, Loading %>"
                                    PromptText="<%$Resources:Titles, Select %>">
                                </ajaxToolkit:CascadingDropDown>
                            </td>
                            <td>
                                <asp:TextBox ID="PriceTextBox" runat="server" CssClass="right" onblur="updateTax();calculateAmount();"
                                    ToolTip="Alt + P" Width="65">
                                </asp:TextBox>
                            </td>
                            <td>
                                <asp:TextBox ID="AmountTextBox" runat="server" CssClass="right" ReadOnly="true" Width="65">
                                </asp:TextBox>
                            </td>
                            <td>
                                <asp:TextBox ID="DiscountTextBox" runat="server" CssClass="right" onblur="updateTax();calculateAmount();"
                                    ToolTip="Ctrl + D" Width="50">
                                </asp:TextBox>
                            </td>
                            <td>
                                <asp:TextBox ID="SubTotalTextBox" runat="server" CssClass="right" ReadOnly="true" Width="65">
                                </asp:TextBox>
                            </td>
                            <td>
                                <asp:TextBox ID="TaxRateTextBox" runat="server" onblur="updateTax();calculateAmount();" CssClass="right" Width="35">
                                </asp:TextBox>
                            </td>
                            <td>
                                <asp:TextBox ID="TaxTextBox" runat="server" CssClass="right" onblur="calculateAmount();" ToolTip="Ctrl + T" Width="45">
                                </asp:TextBox>
                            </td>
                            <td>
                                <asp:TextBox ID="TotalTextBox" runat="server" CssClass="right" ReadOnly="true" Width="70">
                                </asp:TextBox>
                            </td>
                            <td style="width: 52px;">
                                <asp:Button ID="AddButton" runat="server" OnClientClick="calculateAmount();" OnClick="AddButton_Click"
                                    Text="<%$Resources:Titles, Add %>"
                                    ToolTip="CTRL + Enter" />
                            </td>
                        </tr>
                    </table>
                    <asp:Label ID="ErrorLabel" runat="server" CssClass="error" />
                </asp:Panel>
                <div class="vpad8"></div>
                <asp:Table runat="server" CssClass="grid3 grid4">
                    <asp:TableRow ID="ShippingCompanyRow" runat="server">
                        <asp:TableCell>
                            <asp:Literal ID="ShippingCompanyDropDownListLabelLiteral" runat="server" />
                        </asp:TableCell>
                        <asp:TableCell>
                            <asp:DropDownList ID="ShippingCompanyDropDownList" runat="server" Width="200">
                            </asp:DropDownList>
                        </asp:TableCell>
                    </asp:TableRow>
                    <asp:TableRow ID="ShippingChargeRow" runat="server">
                        <asp:TableCell>
                            <asp:Literal ID="ShippingChargeTextBoxLabelLiteral" runat="server" />
                        </asp:TableCell>
                        <asp:TableCell>
                            <asp:TextBox ID="ShippingChargeTextBox" runat="server" AutoPostBack="true" OnTextChanged="ShippingChargeTextBox_TextChanged">
                            </asp:TextBox>
                        </asp:TableCell>

                    </asp:TableRow>
                    <asp:TableRow>
                        <asp:TableCell>
                            <asp:Literal ID="TotalsLiteral" runat="server" Text="<%$Resources:Titles, Totals %>">
                            </asp:Literal>
                        </asp:TableCell>
                        <asp:TableCell>
                            <table style="border-collapse: collapse; width: 100%;">
                                <tr>
                                    <td>
                                        <asp:Literal ID="RunningTotalTextBoxLabelLiteral" runat="server" />
                                    </td>
                                    <td>
                                        <asp:Literal ID="TaxTotalTextBoxLabelLiteral" runat="server" />
                                    </td>
                                    <td>
                                        <asp:Literal ID="GrandTotalTextBoxLabelLiteral" runat="server" />

                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:TextBox ID="RunningTotalTextBox" runat="server" Width="100" ReadOnly="true" />

                                    </td>
                                    <td>
                                        <asp:TextBox ID="TaxTotalTextBox" runat="server" Width="100" ReadOnly="true" />

                                    </td>
                                    <td>
                                        <asp:TextBox ID="GrandTotalTextBox" runat="server" Width="100" ReadOnly="true" />
                                    </td>
                                </tr>
                            </table>
                        </asp:TableCell>
                    </asp:TableRow>
                    <asp:TableRow ID="CashRepositoryRow" runat="server">
                        <asp:TableCell runat="server">
                            <asp:Literal ID="CashRepositoryDropDownListLabelLiteral" runat="server" />
                        </asp:TableCell>
                        <asp:TableCell>
                            <asp:DropDownList ID="CashRepositoryDropDownList" runat="server" 
                                AutoPostBack="true" OnSelectedIndexChanged="CashRepositoryDropDownList_SelectIndexChanged">
                            </asp:DropDownList>
                        </asp:TableCell>
                    </asp:TableRow>
                    <asp:TableRow ID="CashRepositoryBalanceRow" runat="server">
                        <asp:TableCell>
                            <asp:Literal ID="CashRepositoryBalanceTextBoxLabelLiteral" runat="server" />
                        </asp:TableCell>
                        <asp:TableCell>
                            <asp:TextBox ID="CashRepositoryBalanceTextBox" runat="server" Width="100" ReadOnly="true" />
                            <asp:Literal ID="DrLiteral" runat="server" Text="<%$Resources:Titles, Dr %>" />
                        </asp:TableCell>
                    </asp:TableRow>
                    <asp:TableRow>
                        <asp:TableCell>
                            <asp:Literal ID="CostCenterDropDownListLabelLiteral" runat="server" />
                        </asp:TableCell>
                        <asp:TableCell>
                            <asp:DropDownList ID="CostCenterDropDownList" runat="server" Width="300">
                            </asp:DropDownList>
                        </asp:TableCell>
                    </asp:TableRow>
                    <asp:TableRow>
                        <asp:TableCell>
                            <asp:Literal ID="StatementReferenceTextBoxLabelLiteral" runat="server" />
                        </asp:TableCell>
                        <asp:TableCell>
                            <asp:TextBox ID="StatementReferenceTextBox" runat="server" TextMode="MultiLine" Width="400" Height="100">
                            </asp:TextBox>
                        </asp:TableCell>
                    </asp:TableRow>
                    <asp:TableRow>
                        <asp:TableCell>
                        </asp:TableCell>
                        <asp:TableCell>
                            <asp:Button ID="SaveButton" runat="server" Text="<%$Resources:Titles, Save %>" OnClick="SaveButton_Click" />
                        </asp:TableCell>
                    </asp:TableRow>
                </asp:Table>
                <p>
                    <asp:Label ID="ErrorLabelBottom" runat="server" CssClass="error" />
                </p>

            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</div>
<script type="text/javascript">
    areYouSureLocalized = '<%= Resources.Questions.AreYouSure %>';
    updateTaxLocalized = '<%= Resources.Questions.UpdateTax %>';

    var getPrice = function () {
        var itemDropDownList = $('#ItemDropDownList');
        var unitDropDownList = $('#UnitDropDownList');

        if (unitDropDownList.val()) {
            triggerChange(unitDropDownList.attr('id'));
        }
    }



    var calculateAmount = function () {
        var quantityTextBox = $("#QuantityTextBox");
        var priceTextBox = $("#PriceTextBox");
        var amountTextBox = $("#AmountTextBox");
        var discountTextBox = $("#DiscountTextBox");
        var subTotalTextBox = $("#SubTotalTextBox");
        var taxTextBox = $("#TaxTextBox");
        var totalTextBox = $("#TotalTextBox");

        amountTextBox.val(parseFloat2(quantityTextBox.val()) * parseFloat2(priceTextBox.val()));

        subTotalTextBox.val(parseFloat2(amountTextBox.val()) - parseFloat2(discountTextBox.val()));
        totalTextBox.val(parseFloat2(subTotalTextBox.val()) + parseFloat2(taxTextBox.val()));
    }

    var updateTax = function () {

        var taxRateTextBox = $("#TaxRateTextBox");
        var taxTextBox = $("#TaxTextBox");

        var priceTextBox = $("#PriceTextBox");

        var discountTextBox = $("#DiscountTextBox");

        var subTotal = parseFloat2(priceTextBox.val()) - parseFloat2(discountTextBox.val());
        var tax = (subTotal * parseFloat2(taxRateTextBox.val())) / 100;

        if (parseFloat2(tax).toFixed(2) != parseFloat2(taxTextBox.val())) {
            var question = confirm(updateTaxLocalized);
            if (question) {

                if (tax.toFixed) {
                    taxTextBox.val(tax.toFixed(2));
                }
                else {
                    taxTextBox.val(tax);
                }
            }
        }
    }

    function pageLoad() {
        this.calculateAmount();
    }

    $(document).ready(function () {
        shortcut.add("ALT+C", function () {
            $('#ItemCodeTextBox').focus();
        });

        shortcut.add("CTRL+I", function () {
            $('#ItemDropDownList').focus();
        });

        shortcut.add("CTRL+Q", function () {
            $('#QuantityTextBox').focus();
        });

        shortcut.add("ALT+P", function () {
            $('#PriceTextBox').focus();
        });

        shortcut.add("CTRL+D", function () {
            $('#DiscountTextBox').focus();
        });

        shortcut.add("CTRL+T", function () {
            $('#TaxTextBox').focus();
        });

        shortcut.add("CTRL+U", function () {
            $('#UnitDropDownList').focus();
        });

        shortcut.add("CTRL+ENTER", function () {
            $('#AddButton').click();
        });
    });
</script>
