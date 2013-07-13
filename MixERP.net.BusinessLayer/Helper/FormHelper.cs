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

        public static bool InsertRecord(string tableSchema, string tableName, List<KeyValuePair<string, string>> data)
        {
            try
            {
                return MixERP.net.DatabaseLayer.Helper.FormHelper.InsertRecord(tableSchema, tableName, data);
            }
            catch (Exception ex)
            {
                MixERP.net.Common.ExceptionManager.HandleException(ex);
            }

            return false;
        }

        public static bool UpdateRecord(string tableSchema, string tableName, List<KeyValuePair<string, string>> data, string keyColumn, string keyColumnValue)
        {
            try
            {
                return MixERP.net.DatabaseLayer.Helper.FormHelper.UpdateRecord(tableSchema, tableName, data, keyColumn, keyColumnValue);
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
