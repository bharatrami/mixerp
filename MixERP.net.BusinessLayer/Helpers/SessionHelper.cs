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

namespace MixERP.Net.BusinessLayer.Helpers
{
    public static class SessionHelper
    {
        public static long LogOnId()
        {
            return Pes.Utility.Conversion.TryCastLong(HttpContext.Current.Session["LogOnId"]);
        }
        
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

        public static string Nickname()
        {
            return Pes.Utility.Conversion.TryCastString(HttpContext.Current.Session["NickName"]);
        }

        public static string OfficeName()
        {
            return Pes.Utility.Conversion.TryCastString(HttpContext.Current.Session["OfficeName"]);
        }

        public static DateTime RegistrationDate()
        {
            return Pes.Utility.Conversion.TryCastDate(HttpContext.Current.Session["RegistrationDate"]);
        }

        public static string RegistrationNumber()
        {
            return Pes.Utility.Conversion.TryCastString(HttpContext.Current.Session["RegistrationNumber"]);
        }

        public static string PanNumber()
        {
            return Pes.Utility.Conversion.TryCastString(HttpContext.Current.Session["PanNumber"]);
        }

        public static string Street()
        {
            return Pes.Utility.Conversion.TryCastString(HttpContext.Current.Session["Street"]);
        }

        public static string City()
        {
            return Pes.Utility.Conversion.TryCastString(HttpContext.Current.Session["City"]);
        }

        public static string State()
        {
            return Pes.Utility.Conversion.TryCastString(HttpContext.Current.Session["State"]);
        }

        public static string Country()
        {
            return Pes.Utility.Conversion.TryCastString(HttpContext.Current.Session["Country"]);
        }

        public static string ZipCode()
        {
            return Pes.Utility.Conversion.TryCastString(HttpContext.Current.Session["ZipCode"]);
        }

        public static string Phone()
        {
            return Pes.Utility.Conversion.TryCastString(HttpContext.Current.Session["Phone"]);
        }

        public static string Fax()
        {
            return Pes.Utility.Conversion.TryCastString(HttpContext.Current.Session["Fax"]);
        }

        public static string Email()
        {
            return Pes.Utility.Conversion.TryCastString(HttpContext.Current.Session["Email"]);
        }

        public static string Url()
        {
            return Pes.Utility.Conversion.TryCastString(HttpContext.Current.Session["Url"]);
        }

        public static CultureInfo Culture()
        {
            return Pes.Utility.Helpers.LocalizationHelper.Culture();
        }
    }
}
