/********************************************************************************
Copyright (C) Binod Nepal, Mix Open Foundation (http://mixof.org).

This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. 
If a copy of the MPL was not distributed  with this file, You can obtain one at 
http://mozilla.org/MPL/2.0/.
***********************************************************************************/
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace MixERP.Net.DatabaseLayer.DBFactory
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
            connectionStringBuilder.Timeout = 600;

            return connectionStringBuilder.ConnectionString;
        }
    }
}
