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
    public enum VerificationType { Rejected, Closed, Locked, Awaiting, Approved }

    public static class VerificationDomain
    {
        public static short GetVerification(VerificationType type)
        {
            switch(type)
            {
                case VerificationType.Rejected:
                    return -3;
                case VerificationType.Closed:
                    return -2;
                case VerificationType.Locked:
                    return -1;
                case VerificationType.Awaiting:
                    return 0;
                case VerificationType.Approved:
                    return 1;
            }

            return 0;
        }
    }
}
