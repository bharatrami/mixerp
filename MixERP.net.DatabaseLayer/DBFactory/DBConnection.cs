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
