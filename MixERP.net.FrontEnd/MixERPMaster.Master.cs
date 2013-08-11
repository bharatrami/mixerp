/********************************************************************************
Copyright (C) Binod Nepal, Mix Open Foundation (http://mixof.org).

This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. 
If a copy of the MPL was not distributed  with this file, You can obtain one at 
http://mozilla.org/MPL/2.0/.
***********************************************************************************/
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MixERP.Net.FrontEnd
{
    public partial class MixErpMaster : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            this.LoadMenu();
        }

        private void LoadMenu()
        {
            string menu = string.Empty;

            using (DataTable table = MixERP.Net.BusinessLayer.Core.Menu.GetMenuTable(0, 0))
            {
                if (table.Rows.Count > 0)
                {
                    foreach (DataRow row in table.Rows)
                    {
                        string menuText = Pes.Utility.Conversion.TryCastString(row["menu_text"]);
                        string url = Pes.Utility.Conversion.TryCastString(row["url"]);
                        menu += string.Format(MixERP.Net.BusinessLayer.Helpers.SessionHelper.Culture(), "<a href='{0}' title='{1}'>{1}</a>", ResolveUrl(url), menuText);
                    }
                }
            }

            MenuLiteral.Text = menu;
        }
    }
}