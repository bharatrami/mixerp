/********************************************************************************
Copyright (C) Binod Nepal, Mix Open Foundation (http://mixof.org).

This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. 
If a copy of the MPL was not distributed  with this file, You can obtain one at 
http://mozilla.org/MPL/2.0/.
***********************************************************************************/
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Security;

namespace MixERP.Net.BusinessLayer
{
    public class BasePageClass : System.Web.UI.Page
    {
        public bool NoLogOn { get; set; }

        protected override void OnInit(EventArgs e)
        {
            if(!IsPostBack)
            {
                if(Request.IsAuthenticated)
                {
                    if(Context.Session == null)
                    {
                        SetSession();
                    }
                    else
                    {
                        if(Context.Session["UserId"] == null)
                        {
                            SetSession();
                        }
                    }
                }
                else
                {
                    if(!this.NoLogOn)
                    {
                        RequestLogOnPage();
                    }
                }
            }
            base.OnInit(e);
        }

        private void SetSession()
        {
            MixERP.Net.BusinessLayer.Security.User.SetSession(this.Page, User.Identity.Name);
        }

        public static void RequestLogOnPage()
        {
            FormsAuthentication.SignOut();
            string currentUrl = HttpContext.Current.Request.RawUrl;
            string loginPageUrl = FormsAuthentication.LoginUrl;
            HttpContext.Current.Response.Redirect(String.Format(MixERP.Net.BusinessLayer.Helpers.SessionHelper.Culture(), "{0}?ReturnUrl={1}", loginPageUrl, currentUrl));
        }
    }
}
