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
using System.Data;
using System.Linq;
using System.Text;
using Npgsql;

namespace MixERP.net.DatabaseLayer.Office
{
    public static class CashRepositories
    {
        public static DataTable GetCashRepositories()
        {
            string sql = "SELECT * FROM office.cash_repositories;";
            using(NpgsqlCommand command = new NpgsqlCommand(sql))
            {
                return MixERP.net.DatabaseLayer.DBFactory.DBOperations.GetDataTable(command);
            }
        }

        public static DataTable GetCashRepositories(int officeId)
        {
            string sql = "SELECT * FROM office.cash_repositories WHERE office_id=@OfficeId;";
            using(NpgsqlCommand command = new NpgsqlCommand(sql))
            {
                command.Parameters.AddWithValue("@OfficeId", officeId);
                return MixERP.net.DatabaseLayer.DBFactory.DBOperations.GetDataTable(command);
            }
        }

        public static decimal GetBalance(int cashRepositoryId)
        {
            //TODO
            string sql = "select trunc(random() * 9 + 1)::integer  * 1000;";
            using(NpgsqlCommand command = new NpgsqlCommand(sql))
            {
                command.Parameters.AddWithValue("@CashRepositoryId", cashRepositoryId);
                return Pes.Utility.Conversion.TryCastDecimal(MixERP.net.DatabaseLayer.DBFactory.DBOperations.GetScalarValue(command));
            }
        }

    }
}
