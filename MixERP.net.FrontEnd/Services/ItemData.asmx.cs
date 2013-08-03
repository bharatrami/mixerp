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
using System.Web;
using System.Web.Services;
using System.Web.Script.Services;
using System.ComponentModel;
using AjaxControlToolkit;
using System.Collections.Specialized;

namespace MixERP.Net.FrontEnd.Services
{
    /// <summary>
    /// Summary description for ItemData
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [ScriptService]
    public class ItemData : System.Web.Services.WebService
    {

        [WebMethod]
        public CascadingDropDownNameValue[] GetItems(string knownCategoryValues, string category)
        {
            System.Collections.ObjectModel.Collection<CascadingDropDownNameValue> values = new System.Collections.ObjectModel.Collection<CascadingDropDownNameValue>();

            using (System.Data.DataTable table = MixERP.Net.BusinessLayer.Helpers.FormHelper.GetTable("core", "items"))
            {
                foreach (System.Data.DataRow dr in table.Rows)
                {
                    values.Add(new CascadingDropDownNameValue((string)dr["item_name"], dr["item_code"].ToString()));
                }

                return values.ToArray();
            }
        }

        [WebMethod]
        public CascadingDropDownNameValue[] GetUnits(string knownCategoryValues, string category)
        {
            StringDictionary kv = CascadingDropDown.ParseKnownCategoryValuesString(knownCategoryValues);            
            string itemCode = kv["Item"];

            System.Collections.ObjectModel.Collection<CascadingDropDownNameValue> values = new System.Collections.ObjectModel.Collection<CascadingDropDownNameValue>();

            using (System.Data.DataTable table = MixERP.Net.BusinessLayer.Core.Units.GetUnitViewByItemCode(itemCode))
            {
                foreach (System.Data.DataRow dr in table.Rows)
                {
                    values.Add(new CascadingDropDownNameValue((string)dr["unit_name"], dr["unit_id"].ToString()));
                }

                return values.ToArray();
            }
        }

    }
}
