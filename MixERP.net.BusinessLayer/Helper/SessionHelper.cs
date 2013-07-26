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
using System.Web;

namespace MixERP.net.BusinessLayer.Helper
{
    public static class SessionHelper
    {
        public static int UserId()
        {
            return Pes.Utility.Conversion.TryCastInteger(HttpContext.Current.Session["UserId"]);
        }

        public static string UserName()
        {
            return Pes.Utility.Conversion.TryCastString(HttpContext.Current.Session["UserName"]);
        }

        public static int OfficeId()
        {
            return Pes.Utility.Conversion.TryCastInteger(HttpContext.Current.Session["OfficeId"]);
        }

        public static string OfficeName()
        {
            return Pes.Utility.Conversion.TryCastString(HttpContext.Current.Session["OfficeName"]);
        }

        public static CultureInfo Culture()
        {
            //Todo
            CultureInfo culture = new CultureInfo(CultureInfo.InvariantCulture.Name);
            return culture;
        }
    }
}
