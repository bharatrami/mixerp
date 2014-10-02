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

using MixERP.Net.Common;
using MixERP.Net.Common.Models.Transactions;
using MixERP.Net.FrontEnd.Base;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MixERP.Net.Core.Modules.Sales.Confirmation
{
    public partial class Return : MixERPUserControl
    {
        public override void OnControlLoad(object sender, EventArgs e)
        {
            long transactionMasterId = Conversion.TryCastLong(this.Request["TranId"]);

            this.TransactionChecklist1.Text = Resources.Titles.SalesReturn;
            this.TransactionChecklist1.ViewReportButtonText = Resources.Titles.ViewThisReturn;
            this.TransactionChecklist1.EmailReportButtonText = Resources.Titles.EmailThisReturn;
            this.TransactionChecklist1.PartyEmailAddress = Data.Helpers.Parties.GetEmailAddress(TranBook.Sales, SubTranBook.Return, transactionMasterId);

            base.OnControlLoad(sender, e);
        }
    }
}