using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MixERP.net.FrontEnd.Finance.Setup
{
    public partial class AgeingSlabs : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            MixERP.net.FrontEnd.UserControls.Forms.FormControl form = (MixERP.net.FrontEnd.UserControls.Forms.FormControl)this.LoadControl("~/UserControls/Forms/FormControl.ascx");
            form.DenyAdd = false;
            form.DenyEdit = false;
            form.DenyDelete = false;
            form.Width = 1000;
            form.PageSize = 10;


            form.Text = "Ageing Slab Setup";

            form.TableSchema = "core";
            form.Table = "ageing_slabs";
            form.ViewSchema = "core";
            form.View = "ageing_slabs";


            form.KeyColumn = "ageing_slab_id";

            form.DisplayFields = "";
            form.SelectedValues = "";


            FormPlaceHolder.Controls.Add(form);
        }
    }
}