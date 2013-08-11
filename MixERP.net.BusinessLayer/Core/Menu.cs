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
using System.Data;
using System.Data.Common;

namespace MixERP.Net.BusinessLayer.Core
{
    public static class Menu
    {
        public static DataTable GetMenuTable(string path, short level)
        {
            try
            {
                return MixERP.Net.DatabaseLayer.Core.Menu.GetMenuTable(path, level);
            }
            catch (DbException ex)
            {
                MixERP.Net.Common.ExceptionManager.HandleException(ex);
            }

            return null;
        }

        public static DataTable GetRootMenuTable(string path)
        {
            try
            {
                return MixERP.Net.DatabaseLayer.Core.Menu.GetRootMenuTable(path);
            }
            catch(DbException ex)
            {
                MixERP.Net.Common.ExceptionManager.HandleException(ex);
            }

            return null;
        }

        public static DataTable GetMenuTable(int parentMenuId, short level)
        {
            try
            {
                return MixERP.Net.DatabaseLayer.Core.Menu.GetMenuTable(parentMenuId, level);
            }
            catch(DbException ex)
            {
                MixERP.Net.Common.ExceptionManager.HandleException(ex);
            }

            return null;
        }
    }
}
