<%-- 
    Copyright (C) Binod Nepal, Planet Earth Solutions Pvt. Ltd., Kathmandu.
	Released under the terms of the GNU General Public License, GPL, 
	as published by the Free Software Foundation, either version 3 
	of the License, or (at your option) any later version.
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
    See the License here <http://www.gnu.org/licenses/gpl-3.0.html>.
--%>

<%@ Page Title="" Language="C#" MasterPageFile="~/ContentMaster.Master" AutoEventWireup="true" CodeBehind="DirectSales.aspx.cs" Inherits="MixERP.Net.FrontEnd.Sales.Confirmation.DirectSales" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ScriptContentPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="StyleSheetContentPlaceHolder" runat="server">
    <style type="text/css">
    </style>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="BodyContentPlaceHolder" runat="server">
    <div style="display: none;">
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
                TestIframe.Attributes["src"] = ResolveUrl("~/Sales/Confirmation/DirectSalesInovice.aspx?TranId=" + this.Request["TranId"]);


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

    </div>
    <div>
        <iframe runat="server" id="TestIframe" style="height: 500px; width: 100%; border: 1px solid gray;"></iframe>
    </div>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="BottomScriptContentPlaceHolder" runat="server">
</asp:Content>
