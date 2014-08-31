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
using System;
using System.Collections.ObjectModel;
using System.Web.UI.WebControls;
using MixERP.Net.BusinessLayer.Helpers;
using MixERP.Net.Common;
using MixERP.Net.Common.Models.Transactions;

namespace MixERP.Net.BusinessLayer.Transactions
{
    public static class Transaction
    {
        public static long Add(DateTime valueDate, string referenceNumber, int costCenterId, Collection<JournalDetailsModel> details)
        {
            long transactionMasterId = DatabaseLayer.Transactions.Transaction.Add(valueDate, SessionHelper.GetOfficeId(), SessionHelper.GetUserId(), SessionHelper.GetLogOnId(), costCenterId, referenceNumber, details);
            DatabaseLayer.Transactions.Verification.CallAutoVerification(transactionMasterId);
            return transactionMasterId;
        }

        public static decimal GetExchangeRate(int officeId, string currencyCode)
        {
            return DatabaseLayer.Transactions.Transaction.GetExchangeRate(officeId, currencyCode);
        }
    }
}
