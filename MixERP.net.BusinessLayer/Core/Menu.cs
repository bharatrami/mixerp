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
