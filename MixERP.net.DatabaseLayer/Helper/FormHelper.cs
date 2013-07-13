using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Npgsql;
using System.Data;

namespace MixERP.net.DatabaseLayer.Helper
{
    public static class FormHelper
    {
        public static DataTable GetView(string tableSchema, string tableName, string orderBy, int limit, int offset)
        {
            string sql = string.Format("SELECT * FROM {0}.{1} ORDER BY {2} LIMIT {3} OFFSET {4};", tableSchema, tableName, orderBy, limit, offset);
            using (NpgsqlCommand command = new NpgsqlCommand(sql))
            {
                return MixERP.net.DatabaseLayer.DBFactory.DBOperations.GetDataTable(command);
            }
        }

        public static DataTable GetTable(string tableSchema, string tableName)
        {
            string sql = string.Format("SELECT * FROM {0}.{1};", tableSchema, tableName);
            using (NpgsqlCommand command = new NpgsqlCommand(sql))
            {
                return MixERP.net.DatabaseLayer.DBFactory.DBOperations.GetDataTable(command);
            }
        }

        public static DataTable GetTable(string tableSchema, string tableName, string columnName, string columnValue)
        {
            string sql = string.Format("SELECT * FROM {0}.{1} WHERE {2}=@{2};", tableSchema, tableName, columnName);
            using (NpgsqlCommand command = new NpgsqlCommand(sql))
            {
                command.Parameters.AddWithValue("@" + columnName, columnValue);
                return MixERP.net.DatabaseLayer.DBFactory.DBOperations.GetDataTable(command);
            }
        }

        public static int GetTotalRecords(string tableSchema, string tableName)
        {
            string sql = string.Format("SELECT COUNT(*) FROM {0}.{1}", tableSchema, tableName);
            using (NpgsqlCommand command = new NpgsqlCommand(sql))
            {
                return Pes.Utility.Conversion.TryCastInteger(MixERP.net.DatabaseLayer.DBFactory.DBOperations.GetScalarValue(command));
            }
        }

        public static bool InsertRecord(string tableSchema, string tableName, List<KeyValuePair<string, string>> data)
        {
            string columns = string.Empty;
            string columnParamters = string.Empty;

            int counter = 0;

            foreach (KeyValuePair<string, string> pair in data)
            {
                counter++;

                if (counter.Equals(1))
                {
                    columns += pair.Key;
                    columnParamters += "@" + pair.Key;
                }
                else
                {
                    columns += ", " + pair.Key;
                    columnParamters += ", @" + pair.Key;
                }
            }

            string sql = string.Format("INSERT INTO {0}.{1}({2}) SELECT {3};", tableSchema, tableName, columns, columnParamters);
            using (NpgsqlCommand command = new NpgsqlCommand(sql))
            {
                foreach (KeyValuePair<string, string> pair in data)
                {
                    if (string.IsNullOrWhiteSpace(pair.Value))
                    {
                        command.Parameters.AddWithValue("@" + pair.Key, DBNull.Value);
                    }
                    else
                    {
                        command.Parameters.AddWithValue("@" + pair.Key, pair.Value);
                    }
                }

                return MixERP.net.DatabaseLayer.DBFactory.DBOperations.ExecuteNonQuery(command);
            }            
        }
        
        public static bool UpdateRecord(string tableSchema, string tableName, List<KeyValuePair<string, string>> data, string keyColumn, string keyColumnValue)
        {
            string columns = string.Empty;

            int counter = 0;

            foreach (KeyValuePair<string, string> pair in data)
            {
                counter++;

                if (counter.Equals(1))
                {
                    columns += pair.Key + "=@" + pair.Key;
                }
                else
                {
                    columns += ", " + pair.Key + "=@" + pair.Key;
                }
            }

            string sql = string.Format("UPDATE {0}.{1} SET {2} WHERE {3}=@{3};", tableSchema, tableName, columns, keyColumn);
            using (NpgsqlCommand command = new NpgsqlCommand(sql))
            {
                foreach (KeyValuePair<string, string> pair in data)
                {
                    if (string.IsNullOrWhiteSpace(pair.Value))
                    {
                        command.Parameters.AddWithValue("@" + pair.Key, DBNull.Value);
                    }
                    else
                    {
                        command.Parameters.AddWithValue("@" + pair.Key, pair.Value);
                    }
                }
                
                command.Parameters.AddWithValue("@" + keyColumn, keyColumnValue);

                return MixERP.net.DatabaseLayer.DBFactory.DBOperations.ExecuteNonQuery(command);
            }
        }

        public static bool DeleteRecord(string tableSchema, string tableName, string keyColumn, string keyColumnValue)
        {
            string sql = string.Format("DELETE FROM {0}.{1} WHERE {2}=@{2}", tableSchema, tableName, keyColumn);
            using (NpgsqlCommand command = new NpgsqlCommand(sql))
            {
                command.Parameters.AddWithValue("@" + keyColumn, keyColumnValue);

                return MixERP.net.DatabaseLayer.DBFactory.DBOperations.ExecuteNonQuery(command);            
            }
        }
    }
}
