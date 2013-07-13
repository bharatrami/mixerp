using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Npgsql;
using System.Data;

namespace MixERP.net.DatabaseLayer.Security
{
    public static class User
    {
        public static bool SignIn(int officeId, string userName, string password, string browser, string ipAddress, string remoteUser)
        {
            string sql = "SELECT * FROM office.sign_in(@OfficeId, @UserName, @Password, @Browser, @IPAddress, @RemoteUser);";
            using (NpgsqlCommand command = new NpgsqlCommand(sql))
            {
                command.Parameters.AddWithValue("@OfficeId", officeId);
                command.Parameters.AddWithValue("@UserName", userName);
                command.Parameters.AddWithValue("@Password", password);
                command.Parameters.AddWithValue("@Browser", browser);
                command.Parameters.AddWithValue("@IPAddress", ipAddress);
                command.Parameters.AddWithValue("@RemoteUser", remoteUser);

                int result = Pes.Utility.Conversion.TryCastInteger(MixERP.net.DatabaseLayer.DBFactory.DBOperations.GetScalarValue(command));

                return (result > 0);
            }
        }

        public static DataTable GetUserTable(string userName)
        {
            string sql = "SELECT * FROM office.user_view WHERE user_name=@UserName;";
            using (NpgsqlCommand command = new NpgsqlCommand(sql))
            {
                command.Parameters.AddWithValue("@UserName", userName);

                return MixERP.net.DatabaseLayer.DBFactory.DBOperations.GetDataTable(command);
            }
        }
    }
}
