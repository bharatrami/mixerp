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
using System.Data.Common;

namespace MixERP.Net.DatabaseLayer.Helpers
{
    public static class FormHelper
    {
        public static DataTable GetView(string tableSchema, string tableName, string orderBy, int limit, int offset)
        {
            string sql = "SELECT * FROM @TableSchema.@TableName ORDER BY @OrderBy LIMIT @Limit OFFSET @Offset;";

            using(NpgsqlCommand command = new NpgsqlCommand())
            {
                //We are 100% sure that the following paramters do not come from user input.
                //Having said that, it is nice to sanitize the objects before sending it to the database server.
                sql = sql.Replace("@TableSchema", DBFactory.Sanitizer.SanitizeIdentifierName(tableSchema));
                sql = sql.Replace("@TableName", DBFactory.Sanitizer.SanitizeIdentifierName(tableName));
                sql = sql.Replace("@OrderBy", DBFactory.Sanitizer.SanitizeIdentifierName(orderBy));
                sql = sql.Replace("@Limit", Pes.Utility.Conversion.TryCastString(limit));
                sql = sql.Replace("@Offset", Pes.Utility.Conversion.TryCastString(offset));
                command.CommandText = sql;

                return MixERP.Net.DatabaseLayer.DBFactory.DBOperations.GetDataTable(command);
            }
        }

        public static DataTable GetTable(string tableSchema, string tableName)
        {
            string sql = "SELECT * FROM @TableSchema.@TableName;";
            using(NpgsqlCommand command = new NpgsqlCommand())
            {
                sql = sql.Replace("@TableSchema", DBFactory.Sanitizer.SanitizeIdentifierName(tableSchema));
                sql = sql.Replace("@TableName", DBFactory.Sanitizer.SanitizeIdentifierName(tableName));
                command.CommandText = sql;

                return MixERP.Net.DatabaseLayer.DBFactory.DBOperations.GetDataTable(command);
            }
        }

        public static DataTable GetTable(string tableSchema, string tableName, string columnName, string columnValue)
        {
            string sql = "SELECT * FROM @TableSchema.@TableName WHERE @ColumnName=@ColumnValue;";

            using(NpgsqlCommand command = new NpgsqlCommand())
            {
                sql = sql.Replace("@TableSchema", DBFactory.Sanitizer.SanitizeIdentifierName(tableSchema));
                sql = sql.Replace("@TableName", DBFactory.Sanitizer.SanitizeIdentifierName(tableName));
                sql = sql.Replace("@ColumnName", DBFactory.Sanitizer.SanitizeIdentifierName(columnName));

                command.CommandText = sql;

                command.Parameters.AddWithValue("@ColumnValue", columnValue);
                return MixERP.Net.DatabaseLayer.DBFactory.DBOperations.GetDataTable(command);
            }
        }

        public static int GetTotalRecords(string tableSchema, string tableName)
        {
            string sql = "SELECT COUNT(*) FROM @TableSchema.@TableName";
            using(NpgsqlCommand command = new NpgsqlCommand())
            {
                sql = sql.Replace("@TableSchema", DBFactory.Sanitizer.SanitizeIdentifierName(tableSchema));
                sql = sql.Replace("@TableName", DBFactory.Sanitizer.SanitizeIdentifierName(tableName));

                command.CommandText = sql;

                return Pes.Utility.Conversion.TryCastInteger(MixERP.Net.DatabaseLayer.DBFactory.DBOperations.GetScalarValue(command));
            }
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2202:Do not dispose objects multiple times"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Security", "CA2100:Review SQL queries for security vulnerabilities")]
        public static bool InsertRecord(string tableSchema, string tableName, System.Collections.ObjectModel.Collection<KeyValuePair<string, string>> data, string imageColumn)
        {
            if(data == null)
            {
                return false;
            }

            string columns = string.Empty;
            string columnParamters = string.Empty;

            int counter = 0;

            foreach(KeyValuePair<string, string> pair in data)
            {
                counter++;

                if(counter.Equals(1))
                {
                    columns += DBFactory.Sanitizer.SanitizeIdentifierName(pair.Key);
                    columnParamters += "@" + pair.Key;
                }
                else
                {
                    columns += ", " + DBFactory.Sanitizer.SanitizeIdentifierName(pair.Key);
                    columnParamters += ", @" + pair.Key;
                }
            }

            string sql = "INSERT INTO @TableSchema.@TableName(" + columns + ") SELECT " + columnParamters + ";";
            using(NpgsqlCommand command = new NpgsqlCommand())
            {
                sql = sql.Replace("@TableSchema", DBFactory.Sanitizer.SanitizeIdentifierName(tableSchema));
                sql = sql.Replace("@TableName", DBFactory.Sanitizer.SanitizeIdentifierName(tableName));

                command.CommandText = sql;

                foreach(KeyValuePair<string, string> pair in data)
                {
                    if(string.IsNullOrWhiteSpace(pair.Value))
                    {
                        command.Parameters.AddWithValue("@" + pair.Key, DBNull.Value);
                    }
                    else
                    {
                        if(pair.Key.Equals(imageColumn))
                        {
                            using(FileStream stream = new FileStream(pair.Value, FileMode.Open, FileAccess.Read))
                            {
                                using(BinaryReader reader = new BinaryReader(new BufferedStream(stream)))
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

                return MixERP.Net.DatabaseLayer.DBFactory.DBOperations.ExecuteNonQuery(command);
            }
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Security", "CA2100:Review SQL queries for security vulnerabilities")]
        public static bool UpdateRecord(string tableSchema, string tableName, System.Collections.ObjectModel.Collection<KeyValuePair<string, string>> data, string keyColumn, string keyColumnValue, string imageColumn)
        {
            if(data == null)
            {
                return false;
            }

            string columns = string.Empty;

            int counter = 0;

            foreach(KeyValuePair<string, string> pair in data)
            {
                counter++;

                if(counter.Equals(1))
                {
                    columns += DBFactory.Sanitizer.SanitizeIdentifierName(pair.Key) + "=@" + pair.Key;
                }
                else
                {
                    columns += ", " + DBFactory.Sanitizer.SanitizeIdentifierName(pair.Key) + "=@" + pair.Key;
                }
            }

            string sql = "UPDATE @TableSchema.@TableName SET " + columns + " WHERE @KeyColumn=@KeyValue;";

            using(NpgsqlCommand command = new NpgsqlCommand())
            {
                sql = sql.Replace("@TableSchema", DBFactory.Sanitizer.SanitizeIdentifierName(tableSchema));
                sql = sql.Replace("@TableName", DBFactory.Sanitizer.SanitizeIdentifierName(tableName));
                sql = sql.Replace("@KeyColumn", DBFactory.Sanitizer.SanitizeIdentifierName(keyColumn));

                command.CommandText = sql;

                foreach(KeyValuePair<string, string> pair in data)
                {
                    if(string.IsNullOrWhiteSpace(pair.Value))
                    {
                        command.Parameters.AddWithValue("@" + pair.Key, DBNull.Value);
                    }
                    else
                    {
                        if(pair.Key.Equals(imageColumn))
                        {
                            using(FileStream stream = new FileStream(pair.Value, FileMode.Open, FileAccess.Read))
                            {
                                using(BinaryReader reader = new BinaryReader(new BufferedStream(stream)))
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

                command.Parameters.AddWithValue("@KeyValue", keyColumnValue);

                return MixERP.Net.DatabaseLayer.DBFactory.DBOperations.ExecuteNonQuery(command);
            }
        }

        public static bool DeleteRecord(string tableSchema, string tableName, string keyColumn, string keyColumnValue)
        {
            string sql = "DELETE FROM @TableSchema.@TableName WHERE @KeyColumn=@KeyValue";

            using(NpgsqlCommand command = new NpgsqlCommand())
            {
                sql = sql.Replace("@TableSchema", DBFactory.Sanitizer.SanitizeIdentifierName(tableSchema));
                sql = sql.Replace("@TableName", DBFactory.Sanitizer.SanitizeIdentifierName(tableName));
                sql = sql.Replace("@KeyColumn", DBFactory.Sanitizer.SanitizeIdentifierName(keyColumn));
                command.CommandText = sql;

                command.Parameters.AddWithValue("@KeyValue", keyColumnValue);

                return MixERP.Net.DatabaseLayer.DBFactory.DBOperations.ExecuteNonQuery(command);
            }
        }
    }
}
