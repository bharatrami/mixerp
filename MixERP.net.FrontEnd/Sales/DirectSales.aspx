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

<%@ Page Title="" Language="C#" MasterPageFile="~/ContentMaster.Master" AutoEventWireup="true" CodeBehind="DirectSales.aspx.cs" Inherits="MixERP.Net.FrontEnd.Sales.DirectSales" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ScriptContentPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="StyleSheetContentPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="BodyContentPlaceHolder" runat="server">
    <pes:Product runat="server" ID="DirectSalesControl"
       TransactionType="Sales" Text="Direct Sales"
        ShowTransactionType="true"
        ShowCashRepository="true"
        VerifyStock="true"
        TopPanelWidth="750"
        OnSaveButtonClick="Sales_SaveButtonClick"
         />

    <asp:Label ID="ErrorLabel" runat="server" CssClass="error">
    </asp:Label>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="BottomScriptContentPlaceHolder" runat="server">
</asp:Content>

<script runat="server">
    protected void Sales_SaveButtonClick(object sender, EventArgs e)
    {
        DateTime valueDate = Pes.Utility.Conversion.TryCastDate(DirectSalesControl.GetForm.DateTextBox.Text);
        int storeId = Pes.Utility.Conversion.TryCastInteger(DirectSalesControl.GetForm.StoreDropDownList.SelectedItem.Value);
        bool isCredit = DirectSalesControl.GetForm.TransactionTypeRadioButtonList.SelectedItem.Value.Equals(Resources.Titles.Credit); ;
        string customerCode = DirectSalesControl.GetForm.CustomerDropDownList.SelectedItem.Value;
        int priceTypeId = Pes.Utility.Conversion.TryCastInteger(DirectSalesControl.GetForm.PriceTypeDropDownList.SelectedItem.Value);
        GridView grid = DirectSalesControl.GetForm.Grid;
        int cashRepositoryId = Pes.Utility.Conversion.TryCastInteger(DirectSalesControl.GetForm.CashRepositoryDropDownList.SelectedItem.Value);
        int shipperId = Pes.Utility.Conversion.TryCastInteger(DirectSalesControl.GetForm.ShippingCompanyDropDownList.SelectedItem.Value);
        decimal shippingCharge = Pes.Utility.Conversion.TryCastDecimal(DirectSalesControl.GetForm.ShippingChargeTextBox.Text);
        
        int costCenterId = Pes.Utility.Conversion.TryCastInteger(DirectSalesControl.GetForm.CostCenterDropDownList.SelectedItem.Value);
        string statementReference = DirectSalesControl.GetForm.StatementReferenceTextBox.Text;
            
        long transactionMasterId = MixERP.Net.BusinessLayer.Transactions.DirectSales.Add(valueDate, storeId, isCredit, customerCode, priceTypeId, grid, shipperId, shippingCharge, cashRepositoryId, costCenterId, statementReference);
        if(transactionMasterId > 0)
        {
            Response.Redirect("~/Sales/Confirmation/DirectSales.aspx?TranId=" + transactionMasterId, true);
        }
    }
</script>