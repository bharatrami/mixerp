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
using Npgsql;

namespace MixERP.net.DatabaseLayer.Core
{
    public static class Items
    {
        public static bool ItemExistsByCode(string itemCode)
        {
            string sql = "SELECT 1 FROM core.items WHERE core.items.item_code=@ItemCode;";
            using (NpgsqlCommand command = new NpgsqlCommand(sql))
            {
                command.Parameters.AddWithValue("@ItemCode", itemCode);

                return MixERP.net.DatabaseLayer.DBFactory.DBOperations.GetScalarValue(command).ToString().Equals("1");
            }
        }

        public static decimal GetItemSellingPrice(string itemCode, string customerCode, int priceTypeId, int unitId)
        {
            string sql = "SELECT core.get_item_selling_price(core.get_item_id_by_item_code(@ItemCode), core.get_customer_type_id_by_customer_code(@CustomerCode), @PriceTypeId, @UnitId);";
            using(NpgsqlCommand command = new NpgsqlCommand(sql))
            {
                command.Parameters.AddWithValue("@ItemCode", itemCode);
                command.Parameters.AddWithValue("@CustomerCode", customerCode);
                command.Parameters.AddWithValue("@PriceTypeId", priceTypeId);
                command.Parameters.AddWithValue("@UnitId", unitId);

                return Pes.Utility.Conversion.TryCastDecimal(MixERP.net.DatabaseLayer.DBFactory.DBOperations.GetScalarValue(command));
            }
        }

        public static decimal GetItemCostPrice(string itemCode, string supplierCode, int unitId)
        {
            return 100m;
        }

        public static decimal GetTaxRate(string itemCode)
        {
            string sql = "SELECT core.get_item_tax_rate(core.get_item_id_by_item_code(@ItemCode));";
            using (NpgsqlCommand command = new NpgsqlCommand(sql))
            {
                command.Parameters.AddWithValue("@ItemCode", itemCode);
                return Pes.Utility.Conversion.TryCastDecimal(MixERP.net.DatabaseLayer.DBFactory.DBOperations.GetScalarValue(command));
            }
        }

        public static int CountItemInStock(string itemCode, int unitId, int storeId)
        {
            string sql = "SELECT core.count_item_in_stock(core.get_item_id_by_item_code(@ItemCode), @UnitId, @StoreId);";
            using(NpgsqlCommand command = new NpgsqlCommand(sql))
            {
                command.Parameters.AddWithValue("@ItemCode", itemCode);
                command.Parameters.AddWithValue("@UnitId", unitId);
                command.Parameters.AddWithValue("@StoreId", storeId);
                return Pes.Utility.Conversion.TryCastInteger(MixERP.net.DatabaseLayer.DBFactory.DBOperations.GetScalarValue(command));
            }        
        }

    }
}
