<%-- 
Copyright (C) Binod Nepal, Mix Open Foundation (http://mixof.org).

This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. 
If a copy of the MPL was not distributed  with this file, You can obtain one at 
http://mozilla.org/MPL/2.0/.
--%>
<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="TransactionChecklistControl.ascx.cs" Inherits="MixERP.Net.FrontEnd.UserControls.TransactionChecklistControl" %>
<h1>Transaction Successfully Posted</h1>
<hr class="hr" />

<asp:Label ID="VerificationLabel" runat="server" Text="" />

<script runat="server">
    private MixERP.Net.BusinessLayer.Transactions.Models.VerificationModel GetVerificationStatus()
    {
        MixERP.Net.BusinessLayer.Transactions.Models.VerificationModel model = new MixERP.Net.BusinessLayer.Transactions.Models.VerificationModel();
        model.Verification = 0;
        model.VerifierName = "System";
        model.VerifiedDate = System.DateTime.Now;
        model.VerificationReason = "Mistake entry.";

        return model;
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        MixERP.Net.BusinessLayer.Transactions.Models.VerificationModel model = this.GetVerificationStatus();
        string invoiceUrl = ResolveUrl("~/Sales/Confirmation/DirectSalesInovice.aspx?TranId=" + this.Request["TranId"]);
        string printUrl = ResolveUrl("~/Sales/Confirmation/CustomerInvoice.aspx?TranId=" + this.Request["TranId"]);
        string glAdviceUrl = ResolveUrl("~/Finance/Confirmation/GLAdvice.aspx?TranId=" + this.Request["TranId"]);

        ViewButton.Attributes.Add("onclick", "showWindow('" + invoiceUrl + "');return false;");
        PrintButton.Attributes.Add("onclick", "showWindow('" + printUrl + "');return false;");
        ViewGLButton.Attributes.Add("onclick", "showWindow('" + glAdviceUrl + "');return false;");

        switch(model.Verification)
        {
            case -3:
                VerificationLabel.CssClass = "info pink";
                VerificationLabel.Text = string.Format(Resources.Labels.VerificationRejectedMessage, model.VerifierName, model.VerifiedDate.ToString(), model.VerificationReason);
                break;
            case -2:
                VerificationLabel.CssClass = "info red";
                VerificationLabel.Text = string.Format(Resources.Labels.VerificationClosedMessage, model.VerifierName, model.VerifiedDate.ToString(), model.VerificationReason);
                break;
            case -1:
                VerificationLabel.Text = string.Format(Resources.Labels.VerificationWithdrawnMessage, model.VerifierName, model.VerifiedDate.ToString(), model.VerificationReason);
                VerificationLabel.CssClass = "info yellow";
                break;
            case 0:
                VerificationLabel.Text = Resources.Labels.VerificationAwaitingMessage;
                VerificationLabel.CssClass = "info purple";
                break;
            case 1:
            case 2:
                VerificationLabel.Text = string.Format(Resources.Labels.VerificationApprovedMessage, model.VerifierName, model.VerifiedDate.ToString());
                VerificationLabel.CssClass = "info green";
                break;
        }
    }
        
</script>

<br />

<h2>Checklists</h2>
<div class="transaction-confirmation">
    <asp:LinkButton ID="WithdrawButton" runat="server" Text="Withdraw This Transaction" OnClick="WithdrawButton_Click" CssClass="linkblock" />
    <script runat="server">
        protected void WithdrawButton_Click(object sender, EventArgs e)
        {
            bool myTransaction = true;
            DateTime transactionDate = DateTime.Now;

            MixERP.Net.BusinessLayer.Transactions.Models.VerificationModel model = this.GetVerificationStatus();
            if(
                model.Verification.Equals(0) //Awaiting verification 
                ||
                model.Verification.Equals(2) //Automatically Approved by Workflow
                )
            {
                //Withdraw this transaction.                        
                if(myTransaction)
                {
                    MessageLabel.Text = string.Format(Resources.Labels.TransactionWithdrawnMessage, transactionDate.ToShortDateString());
                    MessageLabel.CssClass = "success vpad12";
                }
                else
                {
                    MessageLabel.Text = Resources.Warnings.CannotWithdrawElsesTransaction;
                    MessageLabel.CssClass = "error vpad12";
                }
            }
            else
            {
                MessageLabel.Text = Resources.Warnings.CannotWithdrawTransaction;
                MessageLabel.CssClass = "error vpad12";
            }
        }
    </script>

    <asp:LinkButton ID="ViewButton" runat="server" Text="View This Invoice" CssClass="linkblock" />
    <asp:LinkButton ID="EmailButton" runat="server" Text="Email This Invoice" CssClass="linkblock" />
    <asp:LinkButton ID="PrintButton" runat="server" Text="Print This Invoice" CssClass="linkblock" />
    <asp:LinkButton ID="PrintReceiptButton" runat="server" Text="Print Receipt" CssClass="linkblock" />
    <asp:LinkButton ID="ViewGLButton" runat="server" Text="Print GL Entry of This Invoice" CssClass="linkblock" />
    <asp:LinkButton ID="AttachmentButton" runat="server" Text="Upload Attachments for This Invoice" CssClass="linkblock" />
    <asp:LinkButton ID="BackButton" runat="server" Text="Back" OnClientClick="javascript:history.go(-1);" CssClass="linkblock" />
</div>
<asp:Label ID="MessageLabel" runat="server" Text="" />

<script type="text/javascript">
    var showWindow = function (url) {

        newwindow = window.open(url, name, 'width=' + $('html').width() + ',height=' + $('html').height() + ',toolbar=0,menubar=0,location=0,scrollbars=1,resizable=1');
        newwindow.moveTo(0, 0);
        if (window.focus) { newwindow.focus() }
    }
</script>
