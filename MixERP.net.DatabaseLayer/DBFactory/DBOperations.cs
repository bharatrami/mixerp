﻿using System;
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
