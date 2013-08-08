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

namespace MixERP.Net.DatabaseLayer.Core
{
    public static class Switches
    {
        public static bool AllowSupplierInSales()
        {
            string sql = "SELECT 0 FROM core.switches WHERE switch='Allow Supplier in Sales' AND value=true;";
            using(NpgsqlCommand command = new NpgsqlCommand(sql))
            {
                return MixERP.Net.DatabaseLayer.DBFactory.DBOperations.GetDataTable(command).Rows.Count.Equals(1);
            }
        }

        public static bool AllowNonSupplierInPurchase()
        {
            string sql = "SELECT 0 FROM core.switches WHERE switch='Allow Non Supplier in Purchase' AND value=true;";
            using(NpgsqlCommand command = new NpgsqlCommand(sql))
            {
                return MixERP.Net.DatabaseLayer.DBFactory.DBOperations.GetDataTable(command).Rows.Count.Equals(1);
            }        
        }
    }
}
