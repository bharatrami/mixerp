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

using MixERP.Net.Common;
using MixERP.Net.Common.Helpers;
using MixERP.Net.Common.Models.Transactions;
using MixERP.Net.Messaging.Email;
using MixERP.Net.WebControls.TransactionChecklist;
using Resources;
using System;
using System.Drawing;
using System.Drawing.Imaging;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Net.Mime;
using System.Text.RegularExpressions;
using System.Threading;
using System.Threading.Tasks;
using System.Web;
using System.Web.Hosting;
using System.Windows.Forms;
using UserControl = System.Web.UI.UserControl;

namespace MixERP.Net.FrontEnd.UserControls
{
    /// This class is subject to be moved to a standalone server control class library.
    public partial class TransactionChecklistControl : UserControl
    {
        public string Text { get; set; }

        public string PartyEmailAddress { get; set; }

        public string OverridePath { get; set; }

        public bool DisplayWithdrawButton { get; set; }

        public bool DisplayViewReportButton { get; set; }

        public string ViewReportButtonText { get; set; }

        public bool DisplayEmailReportButton { get; set; }

        public string EmailReportButtonText { get; set; }

        public bool DisplayCustomerReportButton { get; set; }

        public string CustomerReportButtonText { get; set; }

        public bool DisplayPrintReceiptButton { get; set; }

        public bool DisplayPrintGlEntryButton { get; set; }

        public bool DisplayAttachmentButton { get; set; }

        public string AttachmentBookName { get; set; }

        public bool IsNonGlTransaction { get; set; }

        public string ReportPath { get; set; }

        public string CustomerReportPath { get; set; }

        public string GlAdvicePath { get; set; }

        public string ReceiptAdvicePath { get; set; }

        protected void OkButton_Click(object sender, EventArgs e)
        {
            DateTime transactionDate = DateTime.Now;
            long transactionMasterId = Conversion.TryCastLong(this.Request["TranId"]);

            VerificationModel model = Verification.GetVerificationStatus(transactionMasterId);
            if (
                model.Verification.Equals(0) //Awaiting verification
                ||
                model.Verification.Equals(2) //Automatically Approved by Workflow
                )
            {
                //Withdraw this transaction.
                if (transactionMasterId > 0)
                {
                    if (Verification.WithdrawTransaction(transactionMasterId, SessionHelper.GetUserId(), this.ReasonTextBox.Text))
                    {
                        this.MessageLabel.Text = string.Format("The transaction was withdrawn successfully. Moreover, this action will affect the all the reports produced on and after \"{0}\".", transactionDate.ToShortDateString());
                        this.MessageLabel.CssClass = "success vpad12";
                    }
                }
            }
            else
            {
                this.MessageLabel.Text = "Cannot withdraw transaction.";
                this.MessageLabel.CssClass = "error vpad12";
            }

            this.ShowVerificationStatus();
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            long transactionMasterId = Conversion.TryCastLong(this.Request["TranId"]);

            this.TitleLiteral.Text = this.Text;
            this.ViewReportButton.Text = this.ViewReportButtonText;
            this.EmailReportButton.Text = this.EmailReportButtonText;
            this.CustomerReportButton.Text = this.CustomerReportButtonText;

            this.WithdrawButton.Visible = this.DisplayWithdrawButton;
            this.ViewReportButton.Visible = this.DisplayViewReportButton;
            this.EmailReportButton.Visible = this.DisplayEmailReportButton;
            this.CustomerReportButton.Visible = this.DisplayCustomerReportButton;
            this.PrintReceiptButton.Visible = this.DisplayPrintReceiptButton;
            this.PrintGLButton.Visible = this.DisplayPrintGlEntryButton;
            this.AttachmentButton.Visible = this.DisplayAttachmentButton;

            string reportUrl = this.ResolveUrl(this.ReportPath + "?TranId=" + this.Request["TranId"]);
            string customerReportUrl = this.ResolveUrl(this.CustomerReportPath + "?TranId=" + this.Request["TranId"]);
            string glAdviceUrl = this.ResolveUrl(this.GlAdvicePath + "?TranId=" + this.Request["TranId"]);
            string receiptUrl = this.ResolveUrl(this.ReceiptAdvicePath + "?TranId=" + this.Request["TranId"]);

            this.ViewReportButton.Attributes.Add("onclick", "showWindow('" + reportUrl + "');return false;");
            this.ViewReportButton.Attributes.Add("data-url", reportUrl);

            this.CustomerReportButton.Attributes.Add("onclick", "showWindow('" + customerReportUrl + "');return false;");
            this.PrintGLButton.Attributes.Add("onclick", "showWindow('" + glAdviceUrl + "');return false;");
            this.PrintReceiptButton.Attributes.Add("onclick", "showWindow('" + receiptUrl + "');return false;");
            this.AttachmentButton.PostBackUrl = string.Format("~/Modules/BackOffice/AttachmentManager.mix?OverridePath={0}&Book={1}&Id={2}", this.OverridePath, this.AttachmentBookName, transactionMasterId);

            EmailReportButton.Visible = !string.IsNullOrWhiteSpace(this.PartyEmailAddress);

            this.ShowVerificationStatus();
        }

        private void ShowVerificationStatus()
        {
            long transactionMasterId = Conversion.TryCastLong(this.Request["TranId"]);
            VerificationModel model = Verification.GetVerificationStatus(transactionMasterId);

            switch (model.Verification)
            {
                case -3:
                    this.VerificationLabel.CssClass = "alert-danger";
                    this.VerificationLabel.Text = string.Format("This transaction was rejected by {0} on {1}. Reason: \"{2}\".", model.VerifierName, model.VerifiedDate.ToString(LocalizationHelper.GetCurrentCulture()), model.VerificationReason);
                    break;

                case -2:
                    this.VerificationLabel.CssClass = "alert-warning";
                    this.VerificationLabel.Text = string.Format("This transaction was closed by {0} on {1}. Reason: \"{2}\".", model.VerifierName, model.VerifiedDate.ToString(LocalizationHelper.GetCurrentCulture()), model.VerificationReason);
                    break;

                case -1:
                    this.VerificationLabel.Text = string.Format("This transaction was withdrawn by {0} on {1}. Reason: \"{2}\".", model.VerifierName, model.VerifiedDate.ToString(LocalizationHelper.GetCurrentCulture()), model.VerificationReason);
                    this.VerificationLabel.CssClass = "alert-warning";
                    break;

                case 0:
                    this.VerificationLabel.Text = "This transaction is awaiting verification from an administrator.";
                    this.VerificationLabel.CssClass = "alert-info";
                    break;

                case 1:
                case 2:
                    this.VerificationLabel.Text = string.Format("This transaction was approved by {0} on {1}.", model.VerifierName, model.VerifiedDate.ToString(LocalizationHelper.GetCurrentCulture()));
                    this.VerificationLabel.CssClass = "alert-success";
                    break;
            }
        }

        protected void EmailReportButton_Click(object sender, EventArgs e)
        {
            string transactionMasterId = this.Request["TranId"];
            Email email = new Email(EmailHidden.Value, this.Text + " #" + transactionMasterId, this.PartyEmailAddress);
            email.SendEmail();
            Title2Literal.Text = "An email was sent to " + this.PartyEmailAddress + ".";
        }
    }
}