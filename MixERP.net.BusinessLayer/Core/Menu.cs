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
using System.Collections.ObjectModel;

namespace MixERP.Net.BusinessLayer.Core
{
    public static class Menu
    {
        public static Collection<MixERP.Net.Common.Models.Core.Menu> GetMenuCollection(string path, short level)
        {
            try
            {
                Collection<MixERP.Net.Common.Models.Core.Menu> collection = new Collection<Common.Models.Core.Menu>();

                foreach(DataRow row in MixERP.Net.DatabaseLayer.Core.Menu.GetMenuTable(path, level).Rows)
                {
                    MixERP.Net.Common.Models.Core.Menu model = new Common.Models.Core.Menu();

                    model.MenuId = Pes.Utility.Conversion.TryCastInteger(row["menu_id"]);
                    model.MenuText = Pes.Utility.Conversion.TryCastString(row["menu_text"]);
                    model.Url = Pes.Utility.Conversion.TryCastString(row["url"]);
                    model.MenuCode = Pes.Utility.Conversion.TryCastString(row["menu_code"]);
                    model.Level = Pes.Utility.Conversion.TryCastInteger(row["level"]);
                    model.ParentMenuId = Pes.Utility.Conversion.TryCastInteger(row["parent_menu_id"]);

                    collection.Add(model);
                }

                return collection;
            }
            catch(DbException ex)
            {
                MixERP.Net.Common.ExceptionManager.HandleException(ex);
            }

            return null;
        }

        public static Collection<MixERP.Net.Common.Models.Core.Menu> GetRootMenuCollection(string path)
        {
            try
            {
                Collection<MixERP.Net.Common.Models.Core.Menu> collection = new Collection<Common.Models.Core.Menu>();

                foreach(DataRow row in MixERP.Net.DatabaseLayer.Core.Menu.GetRootMenuTable(path).Rows)
                {
                    MixERP.Net.Common.Models.Core.Menu model = new Common.Models.Core.Menu();

                    model.MenuId = Pes.Utility.Conversion.TryCastInteger(row["menu_id"]);
                    model.MenuText = Pes.Utility.Conversion.TryCastString(row["menu_text"]);
                    model.Url = Pes.Utility.Conversion.TryCastString(row["url"]);
                    model.MenuCode = Pes.Utility.Conversion.TryCastString(row["menu_code"]);
                    model.Level = Pes.Utility.Conversion.TryCastInteger(row["level"]);
                    model.ParentMenuId = Pes.Utility.Conversion.TryCastInteger(row["parent_menu_id"]);

                    collection.Add(model);
                }

                return collection;
            }
            catch(DbException ex)
            {
                MixERP.Net.Common.ExceptionManager.HandleException(ex);
            }

            return null;
        }

        public static Collection<MixERP.Net.Common.Models.Core.Menu> GetMenuCollection(int parentMenuId, short level)
        {
            try
            {
                Collection<MixERP.Net.Common.Models.Core.Menu> collection = new Collection<Common.Models.Core.Menu>();

                foreach(DataRow row in MixERP.Net.DatabaseLayer.Core.Menu.GetMenuTable(parentMenuId, level).Rows)
                {
                    MixERP.Net.Common.Models.Core.Menu model = new Common.Models.Core.Menu();

                    model.MenuId = Pes.Utility.Conversion.TryCastInteger(row["menu_id"]);
                    model.MenuText = Pes.Utility.Conversion.TryCastString(row["menu_text"]);
                    model.Url = Pes.Utility.Conversion.TryCastString(row["url"]);
                    model.MenuCode = Pes.Utility.Conversion.TryCastString(row["menu_code"]);
                    model.Level = Pes.Utility.Conversion.TryCastInteger(row["level"]);
                    model.ParentMenuId = Pes.Utility.Conversion.TryCastInteger(row["parent_menu_id"]);

                    collection.Add(model);
                }

                return collection;
            }
            catch(DbException ex)
            {
                MixERP.Net.Common.ExceptionManager.HandleException(ex);
            }

            return null;
        }
    }
}
