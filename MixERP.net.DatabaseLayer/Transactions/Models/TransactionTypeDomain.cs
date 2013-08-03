using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace MixERP.Net.DatabaseLayer.Transactions.Models
{
    public enum TransactionType { Debit, Credit }

    public static class TransactionTypeDomain
    {
        public static string GetDomain(TransactionType type)
        {
            if(type == TransactionType.Debit)
                return "Dr";
            else if(type == TransactionType.Credit)
                return "Cr";
            else
                throw new InvalidOperationException(Pes.Utility.Helpers.LocalizationHelper.GetResourceString("Warnings", "UnknownTransactionType"));
        }

    }
}
