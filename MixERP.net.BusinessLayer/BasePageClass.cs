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

namespace MixERP.net.BusinessLayer
{
    public class BasePageClass : System.Web.UI.Page
    {
        public bool NoLogin { get; set; }

        protected override void OnInit(EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.IsAuthenticated)
                {
                    if (Context.Session != null)
                    {
                        if (Context.Session.IsNewSession)
                        {
                            SetSession();
                        }
                    }
                    else
                    {
                        SetSession();
                    }
                }
                else
                {
                    if (!this.NoLogin)
                    {
                        RequestLoginPage();
                    }
                }
            }
            base.OnInit(e);
        }

        private void SetSession()
        {
            MixERP.net.BusinessLayer.Security.User.SetSession(this.Page, User.Identity.Name);
        }

        private void RequestLoginPage()
        {
            string currentUrl = HttpContext.Current.Request.RawUrl;
            string loginPageUrl = FormsAuthentication.LoginUrl;
            HttpContext.Current.Response.Redirect(String.Format("{0}?ReturnUrl={1}", loginPageUrl, currentUrl));
        }
    }
}
