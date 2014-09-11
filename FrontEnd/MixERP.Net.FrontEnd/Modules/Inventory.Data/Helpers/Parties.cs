﻿using MixERP.Net.Common;
using MixERP.Net.Common.Helpers;
using MixERP.Net.Common.Models.Core;
using MixERP.Net.DBFactory;
using Npgsql;
using System.Collections.ObjectModel;
using System.Data;

namespace MixERP.Net.Core.Modules.Inventory.Data.Helpers
{
    public static class Parties
    {
        public static Collection<PartyShippingAddress> GetShippingAddresses(string partyCode)
        {
            Collection<PartyShippingAddress> addresses = new Collection<PartyShippingAddress>();

            const string sql = "SELECT * FROM core.shipping_addresses WHERE party_id=core.get_party_id_by_party_code(@PartyCode);";
            using (NpgsqlCommand command = new NpgsqlCommand(sql))
            {
                command.Parameters.AddWithValue("@PartyCode", partyCode);
                using (DataTable table = DbOperations.GetDataTable(command))
                {
                    for (int i = 0; i < table.Rows.Count; i++)
                    {
                        PartyShippingAddress address = new PartyShippingAddress();
                        address.POBox = Conversion.TryCastString(table.Rows[i]["po_box"]);
                        address.AddressLine1 = Conversion.TryCastString(table.Rows[i]["address_line_1"]);
                        address.AddressLine2 = Conversion.TryCastString(table.Rows[i]["address_line_2"]);
                        address.Street = Conversion.TryCastString(table.Rows[i]["street"]);
                        address.City = Conversion.TryCastString(table.Rows[i]["city"]);
                        address.State = Conversion.TryCastString(table.Rows[i]["state"]);
                        address.Country = Conversion.TryCastString(table.Rows[i]["country"]);

                        addresses.Add(address);
                    }
                }
            }

            return addresses;
        }

        public static string GetPartyCodeByPartyId(int partyId)
        {
            const string sql = "SELECT party_code FROM core.parties WHERE party_id=@PartyId;";

            using (NpgsqlCommand command = new NpgsqlCommand(sql))
            {
                command.Parameters.AddWithValue("@PartyId", partyId);
                return Conversion.TryCastString(DbOperations.GetScalarValue((command)));
            }
        }

        public static PartyDueModel GetPartyDue(string partyCode)
        {
            PartyDueModel model = new PartyDueModel();

            int officeId = SessionHelper.GetOfficeId();

            using (DataTable table = GetPartyDue(officeId, partyCode))
            {
                if (table.Rows.Count.Equals(1))
                {
                    model.CurrencyCode = Conversion.TryCastString(table.Rows[0]["currency_code"]);
                    model.CurrencySymbol = Conversion.TryCastString(table.Rows[0]["currency_symbol"]);
                    model.TotalDueAmount = Conversion.TryCastDecimal(table.Rows[0]["total_due_amount"]);
                    model.OfficeDueAmount = Conversion.TryCastDecimal(table.Rows[0]["office_due_amount"]);
                    model.AccruedInterest = Conversion.TryCastDecimal(table.Rows[0]["accrued_interest"]);
                    model.LastReceiptDate = Conversion.TryCastDate(table.Rows[0]["last_receipt_date"]);
                    model.TransactionValue = Conversion.TryCastDecimal(table.Rows[0]["transaction_value"]);
                }
            }

            return model;
        }

        private static DataTable GetPartyDue(int officeId, string partyCode)
        {
            const string sql = "SELECT * FROM transactions.get_party_transaction_summary(@OfficeId, core.get_party_id_by_party_code(@PartyCode));";
            using (NpgsqlCommand command = new NpgsqlCommand(sql))
            {
                command.Parameters.AddWithValue("@OfficeId", officeId);
                command.Parameters.AddWithValue("@PartyCode", partyCode);

                return DbOperations.GetDataTable(command);
            }
        }

        public static DataTable GetPartyDataTable()
        {
            return FormHelper.GetTable("core", "parties");
        }

        public static DataTable GetPartyViewDataTable(string partyCode)
        {
            return FormHelper.GetTable("core", "party_view", "party_code", partyCode);
        }
    }
}