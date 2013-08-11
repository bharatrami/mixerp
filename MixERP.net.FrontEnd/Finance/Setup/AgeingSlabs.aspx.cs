/********************************************************************************
Copyright (C) Binod Nepal, Mix Open Foundation (http://mixof.org).

This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. 
If a copy of the MPL was not distributed  with this file, You can obtain one at 
http://mozilla.org/MPL/2.0/.
***********************************************************************************/
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MixERP.Net.FrontEnd.Finance.Setup
{
    public partial class AgeingSlabs : MixERP.Net.BusinessLayer.BasePageClass
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            MixERP.Net.FrontEnd.UserControls.Forms.FormControl form = (MixERP.Net.FrontEnd.UserControls.Forms.FormControl)this.LoadControl("~/UserControls/Forms/FormControl.ascx");
            form.DenyAdd = false;
            form.DenyEdit = false;
            form.DenyDelete = false;
            form.Width = 1000;
            form.PageSize = 10;


            form.Text = Resources.Titles.AgeingSlabSetup;

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