﻿/********************************************************************************
Copyright (C) Binod Nepal, Mix Open Foundation (http://mixof.org).

This file is part of MixERP.

MixERP is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

MixERP is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with MixERP.  If not, see <http://www.gnu.org/licenses/>.
***********************************************************************************/

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MixERP.Net.Common.Base
{
    public class MixERPWebPageBase : Page
    {
        private MixERPPageStatePersister pageStatePersister;

        private class MixERPPageStatePersister : PageStatePersister
        {
            public MixERPPageStatePersister(Page p)
                : base(p)
            {
            }

            public override void Load()
            {
            }

            public override void Save()
            {
            }
        }

        protected override PageStatePersister PageStatePersister
        {
            get
            {
                if (pageStatePersister == null)
                {
                    pageStatePersister = new MixERPPageStatePersister(this);
                }

                return pageStatePersister;
            }
        }

        /// <summary>
        /// Adds the control to the Master Pages' Content Place Holder.
        /// </summary>
        /// <param name="placeHolderId"></param>
        /// <param name="control"></param>
        public void AddToMasterPage(string placeHolderId, Control control)
        {
            var master = this.Page.Master;

            if (master != null)
            {
                using (ContentPlaceHolder placeHolder = PageUtility.FindControlIterative(master, placeHolderId) as ContentPlaceHolder)
                {
                    if (placeHolder != null)
                    {
                        placeHolder.Controls.Add(control);
                    }
                }
            }
        }

        public void AddToPage(string namingContainerId, Control control)
        {
            using (Control namingContainer = PageUtility.FindControlIterative(this.Page, namingContainerId))
            {
                if (namingContainer != null)
                {
                    if (control != null)
                    {
                        namingContainer.Controls.Add(control);
                    }
                }
            }
        }
    }
}