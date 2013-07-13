using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;

namespace MixERP.net.BusinessLayer.Core
{
    public static class Menu
    {
        public static DataTable GetMenuTable(string url, short level)
        {
            try
            {
                return MixERP.net.DatabaseLayer.Core.Menu.GetMenuTable(url, level);
            }
            catch (Exception ex)
            {
                MixERP.net.Common.ExceptionManager.HandleException(ex);
            }

            return null;
        }

        public static DataTable GetRootMenuTable(string url)
        {
            try
            {
                return MixERP.net.DatabaseLayer.Core.Menu.GetRootMenuTable(url);
            }
            catch (Exception ex)
            {
                MixERP.net.Common.ExceptionManager.HandleException(ex);
            }

            return null;
        }

        public static DataTable GetMenuTable(int parentMenuId, short level)
        {
            try
            {
                return MixERP.net.DatabaseLayer.Core.Menu.GetMenuTable(parentMenuId, level);
            }
            catch (Exception ex)
            {
                MixERP.net.Common.ExceptionManager.HandleException(ex);
            }

            return null;
        }
    }
}
