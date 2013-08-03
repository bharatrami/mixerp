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
using System.Data.Common;

namespace MixERP.Net.BusinessLayer.Helpers
{
    public static class FormHelper
    {
        public static DataTable GetView(string tableSchema, string tableName, string orderBy, int limit, int offset)
        {
            try
            {
                return MixERP.Net.DatabaseLayer.Helpers.FormHelper.GetView(tableSchema, tableName, orderBy, limit, offset);
            }
            catch (DbException ex)
            {
                MixERP.Net.Common.ExceptionManager.HandleException(ex);
            }

            return null;
        }
        
        public static DataTable GetTable(string tableSchema, string tableName)
        {
            try
            {
                return MixERP.Net.DatabaseLayer.Helpers.FormHelper.GetTable(tableSchema, tableName);
            }
            catch(DbException ex)
            {
                MixERP.Net.Common.ExceptionManager.HandleException(ex);
            }

            return null;
        }

        public static DataTable GetTable(string tableSchema, string tableName, string columnName, string columnValue)
        {
            try
            {
                return MixERP.Net.DatabaseLayer.Helpers.FormHelper.GetTable(tableSchema, tableName, columnName, columnValue);
            }
            catch(DbException ex)
            {
                MixERP.Net.Common.ExceptionManager.HandleException(ex);
            }

            return null;
        }

        public static int GetTotalRecords(string tableSchema, string tableName)
        {
            try
            {
                return MixERP.Net.DatabaseLayer.Helpers.FormHelper.GetTotalRecords(tableSchema, tableName);
            }
            catch(DbException ex)
            {
                MixERP.Net.Common.ExceptionManager.HandleException(ex);
            }

            return 0;
        }

        public static bool InsertRecord(string tableSchema, string tableName, System.Collections.ObjectModel.Collection<KeyValuePair<string, string>> data, string imageColumn)
        {
            try
            {
                return MixERP.Net.DatabaseLayer.Helpers.FormHelper.InsertRecord(tableSchema, tableName, data, imageColumn);
            }
            catch(DbException ex)
            {
                MixERP.Net.Common.ExceptionManager.HandleException(ex);
            }

            return false;
        }

        public static bool UpdateRecord(string tableSchema, string tableName, System.Collections.ObjectModel.Collection<KeyValuePair<string, string>> data, string keyColumn, string keyColumnValue, string imageColumn)
        {
            try
            {
                return MixERP.Net.DatabaseLayer.Helpers.FormHelper.UpdateRecord(tableSchema, tableName, data, keyColumn, keyColumnValue, imageColumn);
            }
            catch(DbException ex)
            {
                MixERP.Net.Common.ExceptionManager.HandleException(ex);
            }

            return false;
        }

        public static bool DeleteRecord(string tableSchema, string tableName, string keyColumn, string keyColumnValue)
        {
            try
            {
                return MixERP.Net.DatabaseLayer.Helpers.FormHelper.DeleteRecord(tableSchema, tableName, keyColumn, keyColumnValue);
            }
            catch(DbException ex)
            {
                MixERP.Net.Common.ExceptionManager.HandleException(ex);
            }

            return false;
        }
    }
}
