using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;

namespace MixERP.net.Common
{
    public static class ExceptionManager
    {
        public static void HandleException(Exception ex)
        {
            System.Web.HttpContext.Current.Session["ex"] = ex;
            System.Web.HttpContext.Current.Server.Transfer("~/RuntimeError.aspx");
        }
    }
}
