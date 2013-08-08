/********************************************************************************
    Copyright (C) Binod Nepal, Planet Earth Solutions Pvt. Ltd., Kathmandu.
	Released under the terms of the GNU General Public License, GPL, 
	as published by the Free Software Foundation, either version 3 
	of the License, or (at your option) any later version.
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
    See the License here <http://www.gnu.org/licenses/gpl-3.0.html>.
***********************************************************************************/
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;

namespace MixERP.Net.BusinessLayer.Transactions
{
    public static class DirectSales
    {
        public static long Add(DateTime valueDate, int storeId, bool isCredit, string partyCode, int priceTypeId, GridView grid, int shipperId, decimal shippingCharge, int cashRepositoryId, int costCenterId, string statementReference)
        {
            MixERP.Net.DatabaseLayer.Transactions.Models.StockMasterModel stockMaster = new DatabaseLayer.Transactions.Models.StockMasterModel();
            Collection<MixERP.Net.DatabaseLayer.Transactions.Models.StockMasterDetailModel> details = new Collection<DatabaseLayer.Transactions.Models.StockMasterDetailModel>();

            stockMaster.PartyCode = partyCode;
            stockMaster.IsCredit = isCredit;
            stockMaster.PriceTypeId = priceTypeId;
            stockMaster.ShipperId = shipperId;
            stockMaster.ShippingCharge = shippingCharge;

            if(grid != null)
            {
                if(grid.Rows.Count > 0)
                {
                    foreach(GridViewRow row in grid.Rows)
                    {
                        MixERP.Net.DatabaseLayer.Transactions.Models.StockMasterDetailModel detail = new DatabaseLayer.Transactions.Models.StockMasterDetailModel();

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


            return MixERP.Net.DatabaseLayer.Transactions.DirectSales.Add(valueDate, MixERP.Net.BusinessLayer.Helpers.SessionHelper.OfficeId(), MixERP.Net.BusinessLayer.Helpers.SessionHelper.UserId(), MixERP.Net.BusinessLayer.Helpers.SessionHelper.LogOnId(), storeId, cashRepositoryId, costCenterId, statementReference, stockMaster, details);
        }
    }
}
