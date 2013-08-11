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
    public static class Transaction
    {
        public static long Add(DateTime valueDate, string referenceNumber, int costCenterId, GridView grid)
        {
            Collection<MixERP.Net.DatabaseLayer.Transactions.Models.TransactionDetailModel> details = new Collection<DatabaseLayer.Transactions.Models.TransactionDetailModel>();

            if(grid != null)
            {
                if(grid.Rows.Count > 0)
                {
                    foreach(GridViewRow row in grid.Rows)
                    {
                        MixERP.Net.DatabaseLayer.Transactions.Models.TransactionDetailModel detail = new DatabaseLayer.Transactions.Models.TransactionDetailModel();
                        detail.AccountCode = row.Cells[0].Text;
                        detail.CashRepositoryName = row.Cells[2].Text;
                        detail.StatementReference = row.Cells[3].Text;
                        detail.Debit = Pes.Utility.Conversion.TryCastDecimal(row.Cells[4].Text);
                        detail.Credit = Pes.Utility.Conversion.TryCastDecimal(row.Cells[5].Text);

                        details.Add(detail);
                    }
                }
            }


            return MixERP.Net.DatabaseLayer.Transactions.Transaction.Add(valueDate, MixERP.Net.BusinessLayer.Helpers.SessionHelper.OfficeId(), MixERP.Net.BusinessLayer.Helpers.SessionHelper.UserId(), MixERP.Net.BusinessLayer.Helpers.SessionHelper.LogOnId(), costCenterId, referenceNumber, details);
        }
    }
}
