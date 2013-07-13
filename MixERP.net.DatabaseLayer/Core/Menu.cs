using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using Npgsql;

namespace MixERP.net.DatabaseLayer.Core
{
    public static class Menu
    {
        public static DataTable GetMenuTable(string url, short level)
        {
            string sql = "SELECT * FROM core.menus WHERE parent_menu_id=(SELECT menu_id FROM core.menus WHERE url=@url) AND level=@Level ORDER BY menu_id;";
            using (NpgsqlCommand command = new NpgsqlCommand(sql))
            {
                command.Parameters.AddWithValue("@Url", url);
                command.Parameters.AddWithValue("@Level", level);

                return MixERP.net.DatabaseLayer.DBFactory.DBOperations.GetDataTable(command);
            }
        }

        public static DataTable GetRootMenuTable(string url)
        {
            string sql = "SELECT * FROM core.menus WHERE parent_menu_id=core.get_root_parent_menu_id(@url) ORDER BY menu_id;";
            using (NpgsqlCommand command = new NpgsqlCommand(sql))
            {
                command.Parameters.AddWithValue("@Url", url);
                return MixERP.net.DatabaseLayer.DBFactory.DBOperations.GetDataTable(command);
            }
        }

        public static DataTable GetMenuTable(int parentMenuId, short level)
        {
            string sql = "SELECT * FROM core.menus WHERE parent_menu_id is null ORDER BY menu_id;";

            if (parentMenuId > 0)
            {
                sql = "SELECT * FROM core.menus WHERE parent_menu_id=@ParentMenuId AND level=@Level ORDER BY menu_id;";
            }

            using (NpgsqlCommand command = new NpgsqlCommand(sql))
            {
                if (parentMenuId > 0)
                {
                    command.Parameters.AddWithValue("@ParentMenuId", parentMenuId);
                    command.Parameters.AddWithValue("@Level", level);
                }

                return MixERP.net.DatabaseLayer.DBFactory.DBOperations.GetDataTable(command);
            }
        }
    }
}
