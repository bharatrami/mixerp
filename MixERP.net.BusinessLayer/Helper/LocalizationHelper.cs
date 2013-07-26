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
using System.Globalization;
using System.Linq;
using System.Text;

namespace MixERP.net.BusinessLayer.Helper
{
    public static class LocalizationHelper
    {
        public static string GetResourceString(string className, string key)
        {
            if(string.IsNullOrWhiteSpace(key) || System.Web.HttpContext.Current == null)
            {
                return string.Empty;
            }
            try
            {
                return System.Web.HttpContext.GetGlobalResourceObject(className, key, MixERP.net.BusinessLayer.Helper.SessionHelper.Culture()).ToString();
            }
            catch
            {
                throw new InvalidOperationException("Resource could not be found for the key " + key + " on class " + className + " .");
            }
        }
    }
}
