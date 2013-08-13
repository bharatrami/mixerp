/********************************************************************************
Copyright (C) Binod Nepal, Mix Open Foundation (http://mixof.org).

This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. 
If a copy of the MPL was not distributed  with this file, You can obtain one at 
http://mozilla.org/MPL/2.0/.
***********************************************************************************/
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MixERP.Net.FrontEnd.Sales
{
    public partial class DirectSales : MixERP.Net.BusinessLayer.BasePageClass
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void Sales_SaveButtonClick(object sender, EventArgs e)
        {
            DateTime valueDate = Pes.Utility.Conversion.TryCastDate(DirectSalesControl.GetForm.DateTextBox.Text);
            int storeId = Pes.Utility.Conversion.TryCastInteger(DirectSalesControl.GetForm.StoreDropDownList.SelectedItem.Value);
            bool isCredit = DirectSalesControl.GetForm.TransactionTypeRadioButtonList.SelectedItem.Value.Equals(Resources.Titles.Credit); ;
            string partyCode = DirectSalesControl.GetForm.PartyDropDownList.SelectedItem.Value;
            int priceTypeId = Pes.Utility.Conversion.TryCastInteger(DirectSalesControl.GetForm.PriceTypeDropDownList.SelectedItem.Value);
            GridView grid = DirectSalesControl.GetForm.Grid;
            int cashRepositoryId = Pes.Utility.Conversion.TryCastInteger(DirectSalesControl.GetForm.CashRepositoryDropDownList.SelectedItem.Value);
            int shipperId = Pes.Utility.Conversion.TryCastInteger(DirectSalesControl.GetForm.ShippingCompanyDropDownList.SelectedItem.Value);
            decimal shippingCharge = Pes.Utility.Conversion.TryCastDecimal(DirectSalesControl.GetForm.ShippingChargeTextBox.Text);

            int costCenterId = Pes.Utility.Conversion.TryCastInteger(DirectSalesControl.GetForm.CostCenterDropDownList.SelectedItem.Value);
            string statementReference = DirectSalesControl.GetForm.StatementReferenceTextBox.Text;

            long transactionMasterId = MixERP.Net.BusinessLayer.Transactions.DirectSales.Add(valueDate, storeId, isCredit, partyCode, priceTypeId, grid, shipperId, shippingCharge, cashRepositoryId, costCenterId, statementReference);
            if(transactionMasterId > 0)
            {
                Response.Redirect("~/Sales/Confirmation/DirectSales.aspx?TranId=" + transactionMasterId, true);
            }
        }

    }
}