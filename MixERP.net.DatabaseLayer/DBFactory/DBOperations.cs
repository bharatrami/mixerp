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
using System.Globalization;
using System.Data;
using Npgsql;

namespace MixERP.net.DatabaseLayer.DBFactory
{
    public static class DBOperations
    {
        public static bool ExecuteNonQuery(Npgsql.NpgsqlCommand command)
        {
            if (command != null)
            {
                using (Npgsql.NpgsqlConnection connection = new Npgsql.NpgsqlConnection(MixERP.net.DatabaseLayer.DBFactory.DBConnection.ConnectionString()))
                {
                    try
                    {
                        command.Connection = connection;
                        command.CommandTimeout = 300;
                        connection.Open();

                        command.ExecuteNonQuery();
                        return true;
                    }
                    catch
                    {
                        throw;
                    }
                }
            }

            return false;
        }

        public static object GetScalarValue(Npgsql.NpgsqlCommand command)
        {
            if (command != null)
            {
                using (Npgsql.NpgsqlConnection connection = new Npgsql.NpgsqlConnection(MixERP.net.DatabaseLayer.DBFactory.DBConnection.ConnectionString()))
                {
                    command.Connection = connection;
                    command.CommandTimeout = 300;
                    connection.Open();
                    return command.ExecuteScalar();
                }
            }

            return null;
        }

        public static DataTable GetDataTable(Npgsql.NpgsqlCommand command)
        {
            if (command != null)
            {
                using (Npgsql.NpgsqlConnection connection = new Npgsql.NpgsqlConnection(MixERP.net.DatabaseLayer.DBFactory.DBConnection.ConnectionString()))
                {
                    command.Connection = connection;
                    command.CommandTimeout = 300;

                    using (NpgsqlDataAdapter adapter = new NpgsqlDataAdapter(command))
                    {
                        using (DataTable dataTable = new DataTable())
                        {
                            dataTable.Locale = CultureInfo.InvariantCulture;
                            adapter.Fill(dataTable);
                            return dataTable;
                        }
                    }
                }
            }

            return null;
        }

        public static Npgsql.NpgsqlDataReader GetDataReader(Npgsql.NpgsqlCommand command)
        {
            if (command != null)
            {
                Npgsql.NpgsqlDataReader reader = default(Npgsql.NpgsqlDataReader);
                using (Npgsql.NpgsqlConnection connection = new Npgsql.NpgsqlConnection(MixERP.net.DatabaseLayer.DBFactory.DBConnection.ConnectionString()))
                {
                    command.Connection = connection;
                    command.CommandTimeout = 300;

                    command.Connection.Open();
                    reader = command.ExecuteReader(CommandBehavior.CloseConnection);
                    return reader;
                }
            }

            return null;
        }

        public static DataView GetDataView(Npgsql.NpgsqlCommand command)
        {
            if (command != null)
            {
                using (DataView view = new DataView(GetDataTable(command)))
                {
                    return view;
                }
            }

            return null;
        }

        public static Npgsql.NpgsqlDataAdapter GetDataAdapter(Npgsql.NpgsqlCommand command)
        {
            if (command != null)
            {
                using (Npgsql.NpgsqlConnection connection = new Npgsql.NpgsqlConnection(MixERP.net.DatabaseLayer.DBFactory.DBConnection.ConnectionString()))
                {
                    command.Connection = connection;
                    command.CommandTimeout = 300;

                    using (Npgsql.NpgsqlDataAdapter adapter = new Npgsql.NpgsqlDataAdapter(command))
                    {
                        return adapter;
                    }
                }
            }

            return null;
        }

        public static DataSet GetDataSet(Npgsql.NpgsqlCommand command)
        {
            if (command != null)
            {
                using (Npgsql.NpgsqlConnection connection = new Npgsql.NpgsqlConnection(MixERP.net.DatabaseLayer.DBFactory.DBConnection.ConnectionString()))
                {
                    using (Npgsql.NpgsqlDataAdapter adapter = GetDataAdapter(command))
                    {
                        using (DataSet set = new DataSet())
                        {
                            adapter.Fill(set);
                            set.Locale = CultureInfo.CurrentUICulture;
                            return set;
                        }
                    }
                }
            }

            return null;
        }
    }
}
