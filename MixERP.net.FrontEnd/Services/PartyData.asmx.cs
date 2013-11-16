/********************************************************************************
Copyright (C) Binod Nepal, Mix Open Foundation (http://mixof.org).

This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. 
If a copy of the MPL was not distributed  with this file, You can obtain one at 
http://mozilla.org/MPL/2.0/.
***********************************************************************************/
using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Web.Script.Services;
using System.Collections.Generic;
using System.Linq;
using System.Collections;
using System.Web.UI.WebControls;
using System.Collections.ObjectModel;

namespace MixERP.Net.FrontEnd.Services
{
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [ScriptService]
    public class PartyData : System.Web.Services.WebService
    {
        [WebMethod]
        public Collection<ListItem> GetParties()
        {
            Collection<ListItem> values = new Collection<ListItem>();

            using (System.Data.DataTable table = MixERP.Net.BusinessLayer.Helpers.FormHelper.GetTable("core", "parties"))
            {
                string displayField = MixERP.Net.Common.Helpers.ConfigurationHelper.GetDbParameter("PartyDisplayField");
                table.Columns.Add("party", typeof(string), displayField);
                foreach (System.Data.DataRow dr in table.Rows)
                {
                    values.Add(new ListItem(dr["party"].ToString(), dr["party_code"].ToString()));
                }
            }

            return values;
        }

        [WebMethod]
        public Collection<ListItem> GetAddressByPartyCode(string partyCode)
        {
            Collection<ListItem> values = new Collection<ListItem>();

            using (System.Data.DataTable table = MixERP.Net.BusinessLayer.Core.ShippingAddresses.GetShippingAddressView(partyCode))
            {
                string displayField = MixERP.Net.Common.Helpers.ConfigurationHelper.GetDbParameter("ShippingAddressDisplayField");
                table.Columns.Add("shipping_address", typeof(string), displayField);

                foreach (System.Data.DataRow dr in table.Rows)
                {
                    values.Add(new ListItem(dr["shipping_address_code"].ToString(), dr["shipping_address"].ToString()));
                }
            }

            return values;
        }
    }

}
