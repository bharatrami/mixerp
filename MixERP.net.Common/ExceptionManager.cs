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
using System.Web;

namespace MixERP.Net.Common
{
    public static class ExceptionManager
    {
        public static void HandleException(Exception ex)
        {
            System.Web.HttpContext.Current.Session["ex"] = ex;
            System.Web.HttpContext.Current.Response.Redirect("~/RuntimeError.aspx", true);
        }
    }
}
