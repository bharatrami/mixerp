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

namespace MixERP.Net.FrontEnd.Purchase
{
    public partial class Order : MixERP.Net.BusinessLayer.BasePageClass
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void PurchaseOrder_SaveButtonClick(object sender, EventArgs e)
        {
            DateTime valueDate = Pes.Utility.Conversion.TryCastDate(PurchaseOrder.GetForm.DateTextBox.Text);
            string partyCode = PurchaseOrder.GetForm.PartyDropDownList.SelectedItem.Value;
            int priceTypeId = 0;

            if(PurchaseOrder.GetForm.PriceTypeDropDownList.SelectedItem != null)
            {
                priceTypeId = Pes.Utility.Conversion.TryCastInteger(PurchaseOrder.GetForm.PriceTypeDropDownList.SelectedItem.Value);            
            }
            
            GridView grid = PurchaseOrder.GetForm.Grid;
            string statementReference = PurchaseOrder.GetForm.StatementReferenceTextBox.Text;

            long nonGlStockMasterId = MixERP.Net.BusinessLayer.Transactions.NonGlStockTransaction.Add("Purchase.Order", valueDate, partyCode, priceTypeId, grid, statementReference);
            if(nonGlStockMasterId > 0)
            {
                Response.Redirect("~/Dashboard/Index.aspx?TranId=" + nonGlStockMasterId, true);
            }
        }
    }
}