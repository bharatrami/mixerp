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
using System.Web.Security;
using System.Data;

namespace MixERP.net.BusinessLayer.Security
{
    public static class User
    {
        public static void SetSession(System.Web.UI.Page page, string user)
        {
            try
            {
                using (DataTable table = GetUserTable(user))
                {
                    if (table.Rows.Count.Equals(1))
                    {
                        page.Session["UserId"] = table.Rows[0]["user_id"];
                        page.Session["UserName"] = user;

                        page.Session["OfficeId"] = table.Rows[0]["logged_in_office_id"];
                        page.Session["OfficeName"] = table.Rows[0]["logged_in_office"];
                    }
                }
            }
            catch
            {
                //Swallow the exception
            }
        }

        public static bool SignIn(int officeId, string userName, string password, bool remember, System.Web.UI.Page page)
        {
            try
            {
                bool signInSuccess = MixERP.net.DatabaseLayer.Security.User.SignIn(officeId, userName, Pes.Utility.Conversion.HashSha512(password, userName), page.Request.UserAgent, "0", "");

                if (signInSuccess)
                {
                    SetSession(page, userName);

                    FormsAuthenticationTicket ticket = new FormsAuthenticationTicket(1, userName, DateTime.Now, DateTime.Now.AddMinutes(30), remember, String.Empty, FormsAuthentication.FormsCookiePath);
                    string encryptedCookie = FormsAuthentication.Encrypt(ticket);
                    HttpCookie cookie = new HttpCookie(FormsAuthentication.FormsCookieName, encryptedCookie);
                    cookie.Expires = DateTime.Now.AddMinutes(30);
                    page.Response.Cookies.Add(cookie);
                    //FormsAuthentication.RedirectFromLoginPage(userName, false);

                    System.Web.Security.FormsAuthentication.RedirectFromLoginPage(userName, true, "MixERP.net");


                    return true;
                }
            }
            catch
            {
                //Swallow the exception
            }

            return false;
        }

        public static DataTable GetUserTable(string userName)
        {
            try
            {
                return MixERP.net.DatabaseLayer.Security.User.GetUserTable(userName);
            }
            catch (Exception ex)
            {
                MixERP.net.Common.ExceptionManager.HandleException(ex);
            }

            return null;
        }

    }
}
