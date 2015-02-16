﻿/********************************************************************************
Copyright (C) Binod Nepal, Mix Open Foundation (http://mixof.org).

This file is part of MixERP.

MixERP is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

MixERP is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with MixERP.  If not, see <http://www.gnu.org/licenses/>.
***********************************************************************************/

using MixERP.Net.Core.Modules.Finance.Resources;
using MixERP.Net.FrontEnd.Base;
using MixERP.Net.WebControls.ScrudFactory;
using System;
using System.Reflection;
using MixERP.Net.Common.Helpers;
using MixERP.Net.FrontEnd.Controls;

namespace MixERP.Net.Core.Modules.Finance.Setup
{
    public partial class AgeingSlabs : MixERPUserControl
    {
        public override void OnControlLoad(object sender, EventArgs e)
        {
            using (Scrud scrud = new Scrud())
            {
                scrud.KeyColumn = "ageing_slab_id";

                scrud.TableSchema = "core";
                scrud.Table = "ageing_slabs";
                scrud.ViewSchema = "core";
                scrud.View = "ageing_slab_scrud_view";

                scrud.Text = Titles.AgeingSlabs;
                scrud.ResourceAssembly = Assembly.GetAssembly(typeof(AgeingSlabs));

                this.AddScrudCustomValidatorErrorMessages();

                this.ScrudPlaceholder.Controls.Add(scrud);
            }

            
        }

        private void AddScrudCustomValidatorErrorMessages()
        {
            string javascript = JSUtility.GetVar("compareDaysErrorMessageLocalized", Warnings.CompareDaysErrorMessage);

            Common.PageUtility.RegisterJavascript("AgeingSlabs_ScrudCustomValidatorErrorMessages", javascript, this.Page, true);

        }
    }
}