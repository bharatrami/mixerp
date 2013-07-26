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

namespace MixERP.net.BusinessLayer.Helper
{
    public static class MenuHelper
    {
        public static string GetContentPageMenu(System.Web.UI.Page page)
        {
            try
            {
                string menu = string.Empty;

                using (DataTable table = MixERP.net.BusinessLayer.Core.Menu.GetRootMenuTable(page.Request.Url.AbsolutePath))
                {
                    if (table.Rows.Count > 0)
                    {
                        foreach (DataRow row in table.Rows)
                        {
                            int menuId = Pes.Utility.Conversion.TryCastInteger(row["menu_id"]);

                            string menuText = Pes.Utility.Conversion.TryCastString(row["menu_text"]);

                            menu += string.Format(MixERP.net.BusinessLayer.Helper.SessionHelper.Culture(), "<div class='sub-menu'><div class='menu-title'>{0}</div>", menuText);

                            using (DataTable childTable = MixERP.net.BusinessLayer.Core.Menu.GetMenuTable(menuId, 2))
                            {
                                if (childTable.Rows.Count > 0)
                                {
                                    foreach (DataRow childTableRow in childTable.Rows)
                                    {
                                        string url = Pes.Utility.Conversion.TryCastString(childTableRow["url"]);
                                        string childMenuText = Pes.Utility.Conversion.TryCastString(childTableRow["menu_text"]);

                                        menu += string.Format(MixERP.net.BusinessLayer.Helper.SessionHelper.Culture(), "<a href='{0}' title='{1}' class='sub-menu-anchor'>{1}</a>", page.ResolveUrl(url), childMenuText);
                                    }
                                }
                            }

                            menu += "</div>";
                        }
                    }
                }

                return menu;
            }
            catch (Exception ex)
            {
                MixERP.net.Common.ExceptionManager.HandleException(ex);
            }

            return null;
        }

        public static string GetPageMenu(System.Web.UI.Page page)
        {
            try
            {
                string menu = string.Empty;

                using (DataTable table = MixERP.net.BusinessLayer.Core.Menu.GetMenuTable(page.Request.Url.AbsolutePath, 1))
                {
                    if (table.Rows.Count > 0)
                    {
                        foreach (DataRow row in table.Rows)
                        {
                            int menuId = Pes.Utility.Conversion.TryCastInteger(row["menu_id"]);

                            string menuText = Pes.Utility.Conversion.TryCastString(row["menu_text"]);

                            menu += string.Format(MixERP.net.BusinessLayer.Helper.SessionHelper.Culture(), "<div class='menu-panel'><div class='menu-header'>{0}</div><ul>", menuText);

                            using (DataTable childTable = MixERP.net.BusinessLayer.Core.Menu.GetMenuTable(menuId, 2))
                            {
                                if (childTable.Rows.Count > 0)
                                {
                                    foreach (DataRow childTableRow in childTable.Rows)
                                    {
                                        string url = Pes.Utility.Conversion.TryCastString(childTableRow["url"]);
                                        string childMenuText = Pes.Utility.Conversion.TryCastString(childTableRow["menu_text"]);

                                        menu += string.Format(MixERP.net.BusinessLayer.Helper.SessionHelper.Culture(), "<li><a href='{0}' title='{1}'>{1}</a></li>", page.ResolveUrl(url), childMenuText);
                                    }
                                }
                            }

                            menu += "</ul></div>";
                        }
                    }
                }

                menu += "<div style='clear:both;'></div>";
                return menu;
            }
            catch (Exception ex)
            {
                MixERP.net.Common.ExceptionManager.HandleException(ex);
            }

            return null;
        }
    }
}
