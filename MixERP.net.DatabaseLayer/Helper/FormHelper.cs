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
using System.Data;
using System.IO;

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

        public static bool InsertRecord(string tableSchema, string tableName, List<KeyValuePair<string, string>> data, string imageColumn)
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
                        if (pair.Key.Equals(imageColumn))
                        {
                            using (FileStream stream = new FileStream(pair.Value, FileMode.Open, FileAccess.Read))
                            {
                                using (BinaryReader reader = new BinaryReader(new BufferedStream(stream)))
                                {
                                    byte[] byteArray = reader.ReadBytes(Convert.ToInt32(stream.Length));
                                    command.Parameters.AddWithValue("@" + pair.Key, byteArray);
                                }
                            }
                        }
                        else
                        {
                            command.Parameters.AddWithValue("@" + pair.Key, pair.Value);
                        }
                    }
                }

                return MixERP.net.DatabaseLayer.DBFactory.DBOperations.ExecuteNonQuery(command);
            }
        }

        public static bool UpdateRecord(string tableSchema, string tableName, List<KeyValuePair<string, string>> data, string keyColumn, string keyColumnValue, string imageColumn)
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
                        if (pair.Key.Equals(imageColumn))
                        {
                            using (FileStream stream = new FileStream(pair.Value, FileMode.Open, FileAccess.Read))
                            {
                                using (BinaryReader reader = new BinaryReader(new BufferedStream(stream)))
                                {
                                    byte[] byteArray = reader.ReadBytes(Convert.ToInt32(stream.Length));
                                    command.Parameters.AddWithValue("@" + pair.Key, byteArray);
                                }
                            }
                        }
                        else
                        {
                            command.Parameters.AddWithValue("@" + pair.Key, pair.Value);
                        }
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
