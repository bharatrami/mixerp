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
using System.Web.UI;
using System.Globalization;
using System.Net;

namespace Pes.Utility
{
    public static class PageUtility
    {
        public static void RefreshPage(System.Web.UI.Page page)
        {
            if (page != null)
            {
                page.Response.Redirect(page.Request.Url.AbsolutePath);
            }
        }

        public static string GetUserIPAddress()
        {
            Page page = HttpContext.Current.Handler as Page;
            string ip = page.Request.ServerVariables["HTTP_X_FORWARDED_FOR"];
            if (!string.IsNullOrEmpty(ip))
            {
                string[] ipRange = ip.Split(',');
                ip = ipRange[0];
            }
            else
            {
                ip = page.Request.ServerVariables["REMOTE_ADDR"];
            }
            return ip.Trim();
        }

        public static void ExecuteJavaScript(string key, string javascript, Page page)
        {
            ScriptManager.RegisterStartupScript(page, typeof(System.Web.UI.Page), key, javascript, true);
        }

        public static string ResolveUrl(string relativeUrl)
        {
            if (HttpContext.Current != null)
            {
                System.Web.UI.Page p = HttpContext.Current.Handler as System.Web.UI.Page;
                if (p != null)
                {
                    return p.ResolveUrl(relativeUrl);
                }
            }
            return relativeUrl;
        }

        public static bool IsLocalUrl(Uri url, System.Web.UI.Page page)
        {
            if (page == null)
            {
                return false;
            }

            try
            {
                Uri requested = new Uri(page.Request.Url, url);

                if (requested.Host == page.Request.Url.Host)
                {
                    return true;
                }
            }
            catch (InvalidOperationException)
            {
                //
            }

            return false;
        }

        public static int InvalidPasswordAttempts(System.Web.UI.Page page, int increment)
        {
            if (page == null)
            {
                return 0;
            }

            int retVal = 0;
            if (page.Session["InvalidPasswordAttempts"] == null)
            {
                retVal = retVal + increment;
                page.Session.Add("InvalidPasswordAttempts", retVal);
            }
            else
            {
                retVal = Pes.Utility.Conversion.TryCastInteger(page.Session["InvalidPasswordAttempts"]) + increment;
                page.Session["InvalidPasswordAttempts"] = retVal;
            }

            return retVal;
        }

        public static void CheckInvalidAttempts(System.Web.UI.Page page)
        {
            if (page != null)
            {
                if (Pes.Utility.PageUtility.InvalidPasswordAttempts(page, 0) >= Pes.Utility.Conversion.TryCastInteger(System.Configuration.ConfigurationManager.AppSettings["MaxInvalidPasswordAttempts"]))
                {
                    page.Response.Redirect("~/access-denied");
                }
            }
        }

        public static string GetCurrentDomainName()
        {
            string url = System.Web.HttpContext.Current.Request.Url.Scheme + "://" + System.Web.HttpContext.Current.Request.Url.Host;

            if (System.Web.HttpContext.Current.Request.Url.Port != 80)
            {
                url += ":" + System.Web.HttpContext.Current.Request.Url.Port.ToString(CultureInfo.InvariantCulture);
            }

            return url;
        }

        /// <summary>
        /// Check if the input is a valid url.
        /// </summary>
        /// <param name="url"></param>
        /// <returns>Returns input if it's a valid url. If the input is not a valid url, returns empty string.</returns>
        public static string CleanUrl(string url)
        {
            string prefix = "http";

            if (url.Substring(0, prefix.Length) != prefix)
            {
                url = prefix + "://" + url;
            }

            using (var client = new MyClient())
            {
                client.HeadOnly = true;
                try
                {
                    string s1 = client.DownloadString(url);
                }
                catch
                {
                    url = string.Empty;
                }

                return url;
            }

        }

        private class MyClient : WebClient
        {
            public bool HeadOnly { get; set; }

            protected override WebRequest GetWebRequest(Uri address)
            {
                WebRequest req = base.GetWebRequest(address);
                if (HeadOnly && req.Method == "GET")
                {
                    req.Method = "HEAD";
                }
                return req;
            }
        }

    }
}
