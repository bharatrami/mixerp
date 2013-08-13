/********************************************************************************
Copyright (C) Binod Nepal, Mix Open Foundation (http://mixof.org).

This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. 
If a copy of the MPL was not distributed  with this file, You can obtain one at 
http://mozilla.org/MPL/2.0/.
***********************************************************************************/
using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Linq;
using System.Text;
using System.Data;

namespace MixERP.Net.BusinessLayer.Helpers
{
    public static class MenuHelper
    {
        public static string GetContentPageMenu(System.Web.UI.Page page, string path)
        {
            if(page != null)
            {
                try
                {
                    string menu = string.Empty;
                    using(DataTable table = MixERP.Net.BusinessLayer.Core.Menu.GetRootMenuTable(path))
                    {
                        if(table.Rows.Count > 0)
                        {
                            foreach(DataRow row in table.Rows)
                            {
                                int menuId = Pes.Utility.Conversion.TryCastInteger(row["menu_id"]);

                                string menuText = Pes.Utility.Conversion.TryCastString(row["menu_text"]);

                                menu += string.Format(MixERP.Net.BusinessLayer.Helpers.SessionHelper.Culture(), "<div class='sub-menu'><div class='menu-title'>{0}</div>", menuText);

                                using(DataTable childTable = MixERP.Net.BusinessLayer.Core.Menu.GetMenuTable(menuId, 2))
                                {
                                    if(childTable.Rows.Count > 0)
                                    {
                                        foreach(DataRow childTableRow in childTable.Rows)
                                        {
                                            string url = Pes.Utility.Conversion.TryCastString(childTableRow["url"]);
                                            string childMenuText = Pes.Utility.Conversion.TryCastString(childTableRow["menu_text"]);

                                            menu += string.Format(MixERP.Net.BusinessLayer.Helpers.SessionHelper.Culture(), "<a href='{0}' title='{1}' class='sub-menu-anchor'>{1}</a>", page.ResolveUrl(url), childMenuText);
                                        }
                                    }
                                }

                                menu += "</div>";
                            }
                        }
                    }

                    return menu;
                }
                catch(DbException ex)
                {
                    MixERP.Net.Common.ExceptionManager.HandleException(ex);
                }
            }
            return null;
        }

        public static string GetPageMenu(System.Web.UI.Page page)
        {
            if(page != null)
            {
                try
                {
                    string menu = string.Empty;

                    using(DataTable table = MixERP.Net.BusinessLayer.Core.Menu.GetMenuTable(page.Request.Url.AbsolutePath, 1))
                    {
                        if(table.Rows.Count > 0)
                        {
                            foreach(DataRow row in table.Rows)
                            {
                                int menuId = Pes.Utility.Conversion.TryCastInteger(row["menu_id"]);

                                string menuText = Pes.Utility.Conversion.TryCastString(row["menu_text"]);

                                menu += string.Format(MixERP.Net.BusinessLayer.Helpers.SessionHelper.Culture(), "<div class='menu-panel'><div class='menu-header'>{0}</div><ul>", menuText);

                                using(DataTable childTable = MixERP.Net.BusinessLayer.Core.Menu.GetMenuTable(menuId, 2))
                                {
                                    if(childTable.Rows.Count > 0)
                                    {
                                        foreach(DataRow childTableRow in childTable.Rows)
                                        {
                                            string url = Pes.Utility.Conversion.TryCastString(childTableRow["url"]);
                                            string childMenuText = Pes.Utility.Conversion.TryCastString(childTableRow["menu_text"]);

                                            menu += string.Format(MixERP.Net.BusinessLayer.Helpers.SessionHelper.Culture(), "<li><a href='{0}' title='{1}'>{1}</a></li>", page.ResolveUrl(url), childMenuText);
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
                catch(DbException ex)
                {
                    MixERP.Net.Common.ExceptionManager.HandleException(ex);
                }
            }

            return null;
        }
    }
}
