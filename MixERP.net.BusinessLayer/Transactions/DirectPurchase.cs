/********************************************************************************
Copyright (C) Binod Nepal, Mix Open Foundation (http://mixof.org).

This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. 
If a copy of the MPL was not distributed  with this file, You can obtain one at 
http://mozilla.org/MPL/2.0/.
***********************************************************************************/
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;

namespace MixERP.Net.BusinessLayer.Transactions
{
    public static class DirectPurchase
    {
        public static long Add(DateTime valueDate, int storeId, bool isCredit, string partyCode, GridView grid, int cashRepositoryId, int costCenterId, string statementReference)
        {
            MixERP.Net.Common.Transactions.Models.StockMasterModel stockMaster = new MixERP.Net.Common.Transactions.Models.StockMasterModel();
            Collection<MixERP.Net.Common.Transactions.Models.StockMasterDetailModel> details = new Collection<MixERP.Net.Common.Transactions.Models.StockMasterDetailModel>();
            long transactionMasterId = 0;

            stockMaster.PartyCode = partyCode;
            stockMaster.IsCredit = isCredit;

            if(grid != null)
            {
                if(grid.Rows.Count > 0)
                {
                    foreach(GridViewRow row in grid.Rows)
                    {
                        MixERP.Net.Common.Transactions.Models.StockMasterDetailModel detail = new MixERP.Net.Common.Transactions.Models.StockMasterDetailModel();

                        detail.StoreId = storeId;
                        detail.ItemCode = row.Cells[0].Text;
                        detail.Quantity = Pes.Utility.Conversion.TryCastInteger(row.Cells[2].Text);
                        detail.UnitName = row.Cells[3].Text;
                        detail.Price = Pes.Utility.Conversion.TryCastDecimal(row.Cells[4].Text);
                        detail.Discount = Pes.Utility.Conversion.TryCastDecimal(row.Cells[6].Text);
                        detail.TaxRate = Pes.Utility.Conversion.TryCastDecimal(row.Cells[8].Text);
                        detail.Tax = Pes.Utility.Conversion.TryCastDecimal(row.Cells[9].Text);

                        details.Add(detail);
                    }
                }
            }


            transactionMasterId = MixERP.Net.DatabaseLayer.Transactions.DirectPurchase.Add(valueDate, MixERP.Net.BusinessLayer.Helpers.SessionHelper.OfficeId(), MixERP.Net.BusinessLayer.Helpers.SessionHelper.UserId(), MixERP.Net.BusinessLayer.Helpers.SessionHelper.LogOnId(), storeId, cashRepositoryId, costCenterId, statementReference, stockMaster, details);
            MixERP.Net.DatabaseLayer.Transactions.Verification.CallAutoVerification(transactionMasterId);
            return transactionMasterId;
        }
    }
}
