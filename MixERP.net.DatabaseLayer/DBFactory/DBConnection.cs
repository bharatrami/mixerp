using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace MixERP.net.DatabaseLayer.DBFactory
{
    public static class DBConnection
    {
        public static string ConnectionString()
        {
            Npgsql.NpgsqlConnectionStringBuilder connectionStringBuilder = new Npgsql.NpgsqlConnectionStringBuilder();
            connectionStringBuilder.Host = Pes.Utility.Conversion.TryCastString(System.Configuration.ConfigurationManager.AppSettings["Server"]);
            connectionStringBuilder.Database = Pes.Utility.Conversion.TryCastString(System.Configuration.ConfigurationManager.AppSettings["Database"]);
            connectionStringBuilder.UserName = Pes.Utility.Conversion.TryCastString(System.Configuration.ConfigurationManager.AppSettings["UserId"]);
            connectionStringBuilder.Password = Pes.Utility.Conversion.TryCastString(System.Configuration.ConfigurationManager.AppSettings["Password"]);

            return connectionStringBuilder.ConnectionString;
        }
    }
}
