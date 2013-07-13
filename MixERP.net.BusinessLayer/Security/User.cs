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
                        int officeId = Pes.Utility.Conversion.TryCastInteger(table.Rows[0]["office_id"]);
                        string officeName = Pes.Utility.Conversion.TryCastString(table.Rows[0]["office"]);

                        page.Session["UserName"] = user;
                        page.Session["OfficeId"] = officeId;
                        page.Session["OfficeName"] = officeName;
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
                bool signInSuccess = MixERP.net.DatabaseLayer.Security.User.SignIn(officeId, userName, password, page.Request.UserAgent, "0", "");

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
