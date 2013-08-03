/********************************************************************************
    Copyright (C) Binod Nepal, Planet Earth Solutions Pvt. Ltd., Kathmandu.
	Released under the terms of the GNU General Public License, GPL, 
	as published by the Free Software Foundation, either version 3 
	of the License, or (at your option) any later version.
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
    See the License here <http://www.gnu.org/licenses/gpl-3.0.html>.
***********************************************************************************/
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace MixERP.Net.DatabaseLayer.Transactions.Models
{
    public class StockMasterModel
    {
        public long StockMasterId { get; set; }
        public long TransactionMasterId { get; set; }
        public string CustomerCode { get; set; }
        public string SupplierCode { get; set; }
        public int PriceTypeId { get; set; }
        public bool IsCredit { get; set; }
        public int ShipperId { get; set; }
        public decimal ShippingCharge { get; set; }
    }
}
