using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;

namespace MixERP.net.BusinessLayer.Helper
{
    public static class TableHelper
    {
        public static DataTable GetTable(string schema, string tableName, string exclusion)
        {
            try
            {
                return MixERP.net.DatabaseLayer.Helper.TableHelper.GetTable(schema, tableName, exclusion);
            }
            catch (Exception ex)
            {
                MixERP.net.Common.ExceptionManager.HandleException(ex);
            }

            return null;
        }
    }
}
