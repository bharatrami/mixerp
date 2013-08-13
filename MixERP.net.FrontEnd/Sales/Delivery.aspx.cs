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

namespace MixERP.Net.FrontEnd.Sales
{
    public partial class Delivery : MixERP.Net.BusinessLayer.BasePageClass
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            this.LoadParmeters();
            this.LoadGridView();
        }

        protected void GoButton_Click(object sender, EventArgs e)
        {
            using(System.Data.DataTable table = MixERP.Net.BusinessLayer.Helpers.FormHelper.GetTable("core", "account_mini_view", FilterDropDownList.SelectedItem.Value, FilterTextBox.Text, 10))
            {
                SearchGridView.DataSource = table;
                SearchGridView.DataBind();
            }
        }

        private void LoadParmeters()
        {
            using(System.Data.DataTable table = MixERP.Net.BusinessLayer.Helpers.TableHelper.GetTable("core", "account_mini_view", ""))
            {
                FilterDropDownList.DataSource = table;
                FilterDropDownList.DataBind();
            }
        }

        private void LoadGridView()
        {
            using(System.Data.DataTable table = MixERP.Net.BusinessLayer.Helpers.FormHelper.GetTable("core", "account_mini_view", "", "", 10))
            {
                SearchGridView.DataSource = table;
                SearchGridView.DataBind();
            }
        }
    }
}