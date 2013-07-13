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
