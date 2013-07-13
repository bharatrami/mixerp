using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using Npgsql;

namespace MixERP.net.DatabaseLayer.Office
{
    public static class Offices
    {
        public static DataTable GetOffices()
        {
            string sql = "SELECT * FROM office.get_offices();";
            using (NpgsqlCommand command = new NpgsqlCommand(sql))
            {
                return MixERP.net.DatabaseLayer.DBFactory.DBOperations.GetDataTable(command);
            }
        }
    }
}
