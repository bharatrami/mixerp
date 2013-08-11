/********************************************************************************
Copyright (C) Binod Nepal, Mix Open Foundation (http://mixof.org).

This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. 
If a copy of the MPL was not distributed  with this file, You can obtain one at 
http://mozilla.org/MPL/2.0/.
***********************************************************************************/
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.Common;
using System.Web.UI.WebControls;

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
            catch(DbException ex)
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

        public static DataTable GetTable(string tableSchema, string tableName, string columnNames, string columnValues)
        {
            try
            {
                return MixERP.Net.DatabaseLayer.Helpers.FormHelper.GetTable(tableSchema, tableName, columnNames, columnValues);
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

        public static void MakeDirty(WebControl control)
        {
            if(control != null)
            {
                control.CssClass = "dirty";
                control.Focus();
            }
        }

        public static void RemoveDirty(WebControl control)
        {
            if(control != null)
            {
                control.CssClass = "";
            }
        }


    }
}
