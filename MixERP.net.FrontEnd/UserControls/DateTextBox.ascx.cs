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
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MixERP.net.FrontEnd.UserControls
{
    public partial class DateTextBox : System.Web.UI.UserControl
    {
        public new string ID { get; set; }
        public bool Disabled
        {
            get
            {
                return !TextBox1.Enabled;
            }
            set
            {
                TextBox1.Enabled = !value;
            }
        }
        public bool EnableValidation { get; set; }
        public string CssClass {
            get
            {
                return TextBox1.CssClass;
            }
            set
            {
                TextBox1.CssClass = value;
            }
        }
        private string text;
        public string Text
        {
            get
            {
                return TextBox1.Text;
            }
            set
            {
                this.text = value;
            }
        }
        public Unit Width
        {
            get
            {
                return TextBox1.Width;
            }
            set
            {
                TextBox1.Width = value;
            }
        }
        protected void Page_Init(object sender, EventArgs e)
        {
            TextBox1.ID = this.ID;
            
            if(string.IsNullOrEmpty(this.text))
            {
                this.text = DateTime.Now.ToShortDateString();
            }
            
            TextBox1.Text = this.text;
            CalendarExtender1.ID = this.ID + "CalendarExtender";
            CalendarExtender1.TargetControlID = this.ID;
            CalendarExtender1.PopupButtonID = this.ID;


            if(EnableValidation)
            {
                CompareValidator1.ID = this.ID + "CompareValidator";
                CompareValidator1.ControlToValidate = this.ID;
                CompareValidator1.ValueToCompare = "1/1/1900";
                CompareValidator1.Type = ValidationDataType.Date;
                CompareValidator1.ErrorMessage = "Invalid date";
                CompareValidator1.EnableClientScript = true;
                CompareValidator1.CssClass = "error";
            }
            else
            {
                CompareValidator1.Parent.Controls.Remove(CompareValidator1);
            }
        }
    }
}