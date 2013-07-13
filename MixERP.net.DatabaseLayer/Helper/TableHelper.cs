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
