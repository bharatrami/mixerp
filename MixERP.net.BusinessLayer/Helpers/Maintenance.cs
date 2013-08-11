/********************************************************************************
Copyright (C) Binod Nepal, Mix Open Foundation (http://mixof.org).

This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. 
If a copy of the MPL was not distributed  with this file, You can obtain one at 
http://mozilla.org/MPL/2.0/.
***********************************************************************************/
using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Linq;
using System.Text;

namespace MixERP.Net.BusinessLayer.Helpers
{
    public static class Maintenance
    {
        public static void Vacuum()
        {
            try
            {
                MixERP.Net.DatabaseLayer.Helpers.Maintenance.Vacuum();
            }
            catch(DbException ex)
            {
                MixERP.Net.Common.ExceptionManager.HandleException(ex);
            }
        }

        public static void VacuumFull()
        {
            try
            {
                MixERP.Net.DatabaseLayer.Helpers.Maintenance.VacuumFull();
            }
            catch(DbException ex)
            {
                MixERP.Net.Common.ExceptionManager.HandleException(ex);
            }
        }

        public static void Analyze()
        {
            try
            {
                MixERP.Net.DatabaseLayer.Helpers.Maintenance.Analyze();
            }
            catch(DbException ex)
            {
                MixERP.Net.Common.ExceptionManager.HandleException(ex);
            }
        }
    }
}
