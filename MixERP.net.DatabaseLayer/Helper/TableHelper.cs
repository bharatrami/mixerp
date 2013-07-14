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

namespace MixERP.net.DatabaseLayer.Helper
{
    public static class TableHelper
    {
        public static DataTable GetTable(string schema, string tableName, string exclusion)
        {
            string sql = string.Empty;
            
            if (!string.IsNullOrWhiteSpace(exclusion))
            {
                string[] exclusions = exclusion.Split(',');
                string[] paramNames = exclusions.Select((s, i) => "@Paramter" + i.ToString().Trim()).ToArray();
                string inClause = string.Join(",", paramNames);

                sql= string.Format("select * from core.mixerp_table_view where table_schema=@Schema AND table_name=@TableName AND column_name NOT IN({0});", inClause);

                using (NpgsqlCommand command = new NpgsqlCommand(sql))
                {
                    command.Parameters.AddWithValue("@Schema", schema);
                    command.Parameters.AddWithValue("@TableName", tableName);

                    for (int i = 0; i < paramNames.Length; i++)
                    {
                        command.Parameters.AddWithValue(paramNames[i], exclusions[i].Trim());
                    }

                    return MixERP.net.DatabaseLayer.DBFactory.DBOperations.GetDataTable(command);
                }
            }
            else
            {
                sql = "select * from core.mixerp_table_view where table_schema=@Schema AND table_name=@TableName;";

                using (NpgsqlCommand command = new NpgsqlCommand(sql))
                {
                    command.Parameters.AddWithValue("@Schema", schema);
                    command.Parameters.AddWithValue("@TableName", tableName);

                    return MixERP.net.DatabaseLayer.DBFactory.DBOperations.GetDataTable(command);
                }
            
            }
        }

    }
}
