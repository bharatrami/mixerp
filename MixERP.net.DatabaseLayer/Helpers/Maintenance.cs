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

namespace MixERP.Net.DatabaseLayer.Helpers
{
    public static class Maintenance
    {
        public static void Vacuum()
        {
            string sql = "VACUUM;";
            using (Npgsql.NpgsqlCommand command = new Npgsql.NpgsqlCommand(sql))
            {
                command.CommandTimeout = 3600;
                MixERP.Net.DatabaseLayer.DBFactory.DBOperations.ExecuteNonQuery(command);
            }
        }

        public static void VacuumFull()
        {
            string sql = "VACUUM FULL;";
            using (Npgsql.NpgsqlCommand command = new Npgsql.NpgsqlCommand(sql))
            {
                command.CommandTimeout = 3600;
                MixERP.Net.DatabaseLayer.DBFactory.DBOperations.ExecuteNonQuery(command);
            }            
        }

        public static void Analyze()
        {
            string sql = "ANALYZE;";
            using (Npgsql.NpgsqlCommand command = new Npgsql.NpgsqlCommand(sql))
            {
                command.CommandTimeout = 3600;
                MixERP.Net.DatabaseLayer.DBFactory.DBOperations.ExecuteNonQuery(command);
            }
        }
    }
}
