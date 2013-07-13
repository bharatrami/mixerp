using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MixERP.net.FrontEnd.POS
{
    public partial class Index : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string menu = MixERP.net.BusinessLayer.Helper.MenuHelper.GetPageMenu(this.Page);
            MenuLiteral.Text = menu;
        }
    }
}