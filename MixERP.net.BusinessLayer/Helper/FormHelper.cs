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
using System.Data;

namespace MixERP.net.BusinessLayer.Helper
{
    public static class FormHelper
    {
        public static DataTable GetView(string tableSchema, string tableName, string orderBy, int limit, int offset)
        {
            try
            {
                return MixERP.net.DatabaseLayer.Helper.FormHelper.GetView(tableSchema, tableName, orderBy, limit, offset);
            }
            catch (Exception ex)
            {
                MixERP.net.Common.ExceptionManager.HandleException(ex);
            }

            return null;
        }
        
        public static DataTable GetTable(string tableSchema, string tableName)
        {
            try
            {
                return MixERP.net.DatabaseLayer.Helper.FormHelper.GetTable(tableSchema, tableName);
            }
            catch (Exception ex)
            {
                MixERP.net.Common.ExceptionManager.HandleException(ex);
            }

            return null;
        }

        public static DataTable GetTable(string tableSchema, string tableName, string columnName, string columnValue)
        {
            try
            {
                return MixERP.net.DatabaseLayer.Helper.FormHelper.GetTable(tableSchema, tableName, columnName, columnValue);
            }
            catch (Exception ex)
            {
                MixERP.net.Common.ExceptionManager.HandleException(ex);
            }

            return null;
        }

        public static int GetTotalRecords(string tableSchema, string tableName)
        {
            try
            {
                return MixERP.net.DatabaseLayer.Helper.FormHelper.GetTotalRecords(tableSchema, tableName);
            }
            catch (Exception ex)
            {
                MixERP.net.Common.ExceptionManager.HandleException(ex);
            }

            return 0;
        }

        public static bool InsertRecord(string tableSchema, string tableName, List<KeyValuePair<string, string>> data, string imageColumn)
        {
            try
            {
                return MixERP.net.DatabaseLayer.Helper.FormHelper.InsertRecord(tableSchema, tableName, data, imageColumn);
            }
            catch (Exception ex)
            {
                MixERP.net.Common.ExceptionManager.HandleException(ex);
            }

            return false;
        }

        public static bool UpdateRecord(string tableSchema, string tableName, List<KeyValuePair<string, string>> data, string keyColumn, string keyColumnValue, string imageColumn)
        {
            try
            {
                return MixERP.net.DatabaseLayer.Helper.FormHelper.UpdateRecord(tableSchema, tableName, data, keyColumn, keyColumnValue, imageColumn);
            }
            catch (Exception ex)
            {
                MixERP.net.Common.ExceptionManager.HandleException(ex);
            }

            return false;
        }

        public static bool DeleteRecord(string tableSchema, string tableName, string keyColumn, string keyColumnValue)
        {
            try
            {
                return MixERP.net.DatabaseLayer.Helper.FormHelper.DeleteRecord(tableSchema, tableName, keyColumn, keyColumnValue);
            }
            catch (Exception ex)
            {
                MixERP.net.Common.ExceptionManager.HandleException(ex);
            }

            return false;
        }
    }
}
