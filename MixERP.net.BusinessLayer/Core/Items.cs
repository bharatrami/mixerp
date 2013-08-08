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
using System.Linq;
using System.Text;

namespace MixERP.Net.BusinessLayer.Core
{
    public static class Items
    {
        public static bool ItemExistsByCode(string itemCode)
        {
            return MixERP.Net.DatabaseLayer.Core.Items.ItemExistsByCode(itemCode);
        }

        public static decimal GetItemSellingPrice(string itemCode, string partyCode, int priceTypeId, int unitId)
        {
            return MixERP.Net.DatabaseLayer.Core.Items.GetItemSellingPrice(itemCode, partyCode, priceTypeId, unitId);
        }

        public static decimal GetItemCostPrice(string itemCode, string partyCode, int unitId)
        {
            return MixERP.Net.DatabaseLayer.Core.Items.GetItemCostPrice(itemCode, partyCode, unitId);
        }

        public static decimal GetTaxRate(string itemCode)
        {
            return MixERP.Net.DatabaseLayer.Core.Items.GetTaxRate(itemCode);
        }

        public static int CountItemInStock(string itemCode, int unitId, int storeId)
        {
            return MixERP.Net.DatabaseLayer.Core.Items.CountItemInStock(itemCode, unitId, storeId);
        }
    }
}
