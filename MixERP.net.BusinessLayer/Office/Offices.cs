using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace MixERP.net.BusinessLayer.Office
{
    public static class Offices
    {
        public static DataTable GetOffices()
        {
            try
            {
                return MixERP.net.DatabaseLayer.Office.Offices.GetOffices();
            }
            catch (Exception ex)
            {
                MixERP.net.Common.ExceptionManager.HandleException(ex);
            }

            return null;
        }
    }
}
