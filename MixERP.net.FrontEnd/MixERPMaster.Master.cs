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