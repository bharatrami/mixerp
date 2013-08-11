<%-- 
Copyright (C) Binod Nepal, Mix Open Foundation (http://mixof.org).

This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. 
If a copy of the MPL was not distributed  with this file, You can obtain one at 
http://mozilla.org/MPL/2.0/.
--%>
<%@ Page Title="" Language="C#" MasterPageFile="~/ContentMaster.Master" AutoEventWireup="true" CodeBehind="JournalVoucher.aspx.cs" Inherits="MixERP.Net.FrontEnd.Finance.JournalVoucher" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ScriptContentPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="StyleSheetContentPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="BodyContentPlaceHolder" runat="server">
    <asp:ScriptManager runat="server" />
    <asp:Label ID="TitleLabel" runat="server" Text="Journal Voucher Entry" CssClass="title" />



    <asp:UpdateProgress ID="UpdateProgress1" runat="server">
        <ProgressTemplate>
            <div class="ajax-container">
                <img alt="progress" src="/spinner.gif" class="ajax-loader" />
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>

    <asp:UpdatePanel ID="UpdatePanel1" runat="server" ChildrenAsTriggers="true" UpdateMode="Always">
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="AddButton" />
        </Triggers>
        <ContentTemplate>

            <div class="vpad8">
                <div class="form" style="width: 272px;">
                    <table>
                        <tr>
                            <td>
                                <asp:Literal ID="ValueDateLiteral" runat="server" />
                            </td>
                            <td>
                                <asp:Literal ID="ReferenceNumberLiteral" runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <mixerp:DateTextBox ID="ValueDateTextBox" runat="server" Width="100" CssClass="date" />
                            </td>
                            <td>
                                <asp:TextBox ID="ReferenceNumberTextBox" runat="server" Width="100" />
                            </td>
                        </tr>
                    </table>
                </div>
            </div>

            <asp:GridView ID="TransactionGridView" runat="server" EnableTheming="False"
                CssClass="grid2" ShowHeaderWhenEmpty="true" AutoGenerateColumns="false"
                OnRowDataBound="TransactionGridView_RowDataBound"
                OnRowCommand="TransactionGridView_RowCommand"
                Width="1000">
                <Columns>
                    <asp:BoundField DataField="AccountCode" HeaderText="<%$ Resources:Titles, AccountCode %>" HeaderStyle-Width="110" />
                    <asp:BoundField DataField="Account" HeaderText="<%$ Resources:Titles, Account %>" HeaderStyle-Width="250" />
                    <asp:BoundField DataField="CashRepository" HeaderText="<%$ Resources:Titles, CashRepository %>" HeaderStyle-Width="100" />
                    <asp:BoundField DataField="StatementReference" HeaderText="<%$ Resources:Titles, StatementReference %>" HeaderStyle-Width="320" />
                    <asp:BoundField DataField="Debit" HeaderText="<%$ Resources:Titles, Debit %>" HeaderStyle-Width="70" />
                    <asp:BoundField DataField="Credit" HeaderText="<%$ Resources:Titles, Credit %>" HeaderStyle-Width="70" />

                    <asp:TemplateField ShowHeader="False" HeaderText="<%$ Resources:Titles, Action %>">
                        <ItemTemplate>
                            <asp:ImageButton ID="DeleteImageButton" ClientIDMode="Predictable" runat="server"
                                CausesValidation="false"
                                OnClientClick="return(confirmAction());"
                                ImageUrl="~/Resource/Icons/delete-16.png" />
                        </ItemTemplate>
                    </asp:TemplateField>

                </Columns>
                <AlternatingRowStyle CssClass="grid2-row-alt" />
                <HeaderStyle CssClass="grid2-header" />
                <RowStyle CssClass="grid2-row" />
            </asp:GridView>

            <div class="grid3">
                <table class="valignmiddle">
                    <tr>
                        <td>
                            <asp:TextBox ID="AccountCodeTextBox" runat="server" Width="100"
                                onblur="selectItem(this.id, 'AccountDropDownList');" ToolTip="Alt + C" />
                        </td>
                        <td>
                            <asp:DropDownList ID="AccountDropDownList" runat="server" Width="250"
                                onchange="document.getElementById('AccountCodeTextBox').value = this.options[this.selectedIndex].value;if(this.selectedIndex == 0) { return false };"
                                ToolTip="Ctrl + A" />

                            <ajaxToolkit:CascadingDropDown ID="AccountDropDownListCascadingDropDown" runat="server"
                                TargetControlID="AccountDropDownList" Category="Account" ServiceMethod="GetAccounts"
                                ServicePath="~/Services/AccountData.asmx"
                                LoadingText="<%$Resources:Labels, Loading %>"
                                PromptText="<%$Resources:Titles, Select %>">
                            </ajaxToolkit:CascadingDropDown>


                        </td>
                        <td>
                            <asp:DropDownList ID="CashRepositoryDropDownList" runat="server" Width="100" />

                            <ajaxToolkit:CascadingDropDown ID="CashRepositoryDropDownListCascadingDropDown" runat="server"
                                ParentControlID="AccountDropDownList" TargetControlID="CashRepositoryDropDownList"
                                Category="CashRepository" ServiceMethod="GetCashRepositories"
                                ServicePath="~/Services/AccountData.asmx"
                                LoadingText="<%$Resources:Labels, Loading %>"
                                PromptText="<%$Resources:Titles, Select %>">
                            </ajaxToolkit:CascadingDropDown>
                        </td>
                        <td>
                            <asp:TextBox ID="StatementReferenceTextBox" runat="server" Width="315"
                                ToolTip="Ctrl + S" />
                        </td>
                        <td>
                            <asp:TextBox ID="DebitTextBox" runat="server" Width="62"
                                ToolTip="Ctrl + D" onfocus="getDebit();" />
                        </td>
                        <td>
                            <asp:TextBox ID="CreditTextBox" runat="server" Width="62"
                                ToolTip="Ctrl + R" onfocus="getCredit();" />
                        </td>
                        <td>
                            <asp:Button ID="AddButton" runat="server" Text="Add" Width="60" Height="24" OnClick="AddButton_Click" />
                        </td>
                    </tr>
                </table>
            </div>

            <div class="vpad8">
                <div class="form" style="width: 400px;">
                    <table>
                        <tr>
                            <td>
                                <asp:Literal ID="CostCenterLiteral" runat="server" />
                            </td>
                            <td>
                                <asp:DropDownList ID="CostCenterDropDownList" runat="server" Width="250" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="DebitTotalLiteral" runat="server" />
                            </td>
                            <td>
                                <asp:TextBox ID="DebitTotalTextBox" runat="server" ReadOnly="true" Width="140" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="CreditTotalLiteral" runat="server" />
                            </td>
                            <td>
                                <asp:TextBox ID="CreditTotalTextBox" runat="server" ReadOnly="true" Width="140" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td>
                                <asp:Button ID="PostTransactionButton" runat="server" Text="Post Transaction" CssClass="button" Height="30" Width="120" OnClick="PostTransactionButton_Click" />
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="BottomScriptContentPlaceHolder" runat="server">
    <script type="text/javascript">
        areYouSureLocalized = '<%= Resources.Questions.AreYouSure %>';

        $(document).ready(function () {
            shortcut.add("ALT+C", function () {
                $('#AccountCodeTextBox').focus();
            });

            shortcut.add("CTRL+A", function () {
                $('#AccountDropDownList').focus();
            });

            shortcut.add("CTRL+S", function () {
                $('#StatementReferenceTextBox').focus();
            });

            shortcut.add("CTRL+D", function () {
                $('#DebitTextBox').focus();
            });

            shortcut.add("CTRL+R", function () {
                $('#CreditTextBox').focus();
            });

            shortcut.add("CTRL+ENTER", function () {
                $('#AddButton').click();
            });
        });

        var getDebit = function () {
            var drTotal = parseFloat2($("#DebitTotalTextBox").val());
            var crTotal = parseFloat2($("#CreditTotalTextBox").val());
            var debitTextBox = $("#DebitTextBox");
            var creditTextBox = $("#CreditTextBox");

            if (crTotal > drTotal) {
                if (debitTextBox.val() == '' && creditTextBox.val() == '') {
                    debitTextBox.val(crTotal - drTotal);
                }
            }
        }

        var getCredit = function () {
            var drTotal = parseFloat2($("#DebitTotalTextBox").val());
            var crTotal = parseFloat2($("#CreditTotalTextBox").val());
            var debitTextBox = $("#DebitTextBox");
            var creditTextBox = $("#CreditTextBox");

            if (drTotal > crTotal) {
                if (debitTextBox.val() == '' && creditTextBox.val() == '') {
                    creditTextBox.val(drTotal - crTotal);
                }
            }
        }

    </script>
</asp:Content>


<script runat="server">

    protected void PostTransactionButton_Click(object sender, EventArgs e)
    {
        DateTime valueDate = Pes.Utility.Conversion.TryCastDate(ValueDateTextBox.Text);
        string referenceNumber = ReferenceNumberTextBox.Text;
        int costCenterId = Pes.Utility.Conversion.TryCastInteger(CostCenterDropDownList.SelectedItem.Value);

        double transactionId = MixERP.Net.BusinessLayer.Transactions.Transaction.Add(valueDate, referenceNumber, costCenterId, TransactionGridView);

        if(transactionId > 0)
        {
            Response.Redirect("~/Finance/Confirmation/JournalVoucher.aspx?TranId=" + transactionId, true);
        }
    }
    protected void TransactionGridView_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if(e.Row.RowType == DataControlRowType.DataRow)
        {
            ImageButton lb = e.Row.FindControl("DeleteImageButton") as ImageButton;
            ScriptManager.GetCurrent(this.Page).RegisterAsyncPostBackControl(lb);
        }
    }

    protected void TransactionGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        using(System.Data.DataTable table = this.GetTable())
        {
            GridViewRow row = (GridViewRow)(((ImageButton)e.CommandSource).NamingContainer);
            int index = row.RowIndex;

            table.Rows.RemoveAt(index);
            Session[this.ID] = table;
            this.BindGridView();
        }
    }


    protected void Page_Init(object sender, EventArgs e)
    {
        if(!IsPostBack)
        {
            if(Session[this.ID] != null)
            {
                Session.Remove(this.ID);
            }
        }
        this.InitializeControls();
        this.BindGridView();
    }

    private void InitializeControls()
    {
        ValueDateLiteral.Text = "<label for='ValueDateTextBox'>" + Resources.Titles.ValueDate + "</label>";
        ReferenceNumberLiteral.Text = "<label for='ReferenceNumberTextBox'>" + Resources.Titles.ReferenceNumber + "</label>";


        CostCenterLiteral.Text = "<label for='CostCenterDropDownList'>" + Resources.Titles.CostCenter + "</label>";
        DebitTotalLiteral.Text = "<label for='DebitTotalTextBox'>" + Resources.Titles.DebitTotal + "</label>";
        CreditTotalLiteral.Text = "<label for='CreditTotalTextBox'>" + Resources.Titles.CreditTotal + "</label>";
    }

    private System.Data.DataTable GetTable()
    {
        if(Session[this.ID] != null)
        {
            return (System.Data.DataTable)Session[this.ID];
        }

        using(System.Data.DataTable table = new System.Data.DataTable())
        {
            table.Locale = MixERP.Net.BusinessLayer.Helpers.SessionHelper.Culture();

            table.Columns.Add("AccountCode");
            table.Columns.Add("Account");
            table.Columns.Add("CashRepository");
            table.Columns.Add("StatementReference");
            table.Columns.Add("Debit");
            table.Columns.Add("Credit");
            return table;
        }
    }

    private void AddRowToTable(string accountCode, string account, string cashRepository, string statementReference, decimal debit, decimal credit)
    {
        using(System.Data.DataTable table = this.GetTable())
        {
            System.Data.DataRow row = table.NewRow();
            row[0] = accountCode;
            row[1] = account;
            row[2] = cashRepository;
            row[3] = statementReference;
            row[4] = debit;
            row[5] = credit;

            table.Rows.Add(row);
            Session[this.ID] = table;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        this.DataBindControls();
    }

    protected void AddButton_Click(object sender, EventArgs e)
    {
        string accountCode = AccountCodeTextBox.Text;
        string account = AccountDropDownList.SelectedItem.Text;
        string statementReference = StatementReferenceTextBox.Text;
        string cashRepository = CashRepositoryDropDownList.SelectedItem.Text;
        decimal debit = Pes.Utility.Conversion.TryCastDecimal(DebitTextBox.Text);
        decimal credit = Pes.Utility.Conversion.TryCastDecimal(CreditTextBox.Text);

        #region Validation
        if(string.IsNullOrWhiteSpace(accountCode))
        {
            MixERP.Net.BusinessLayer.Helpers.FormHelper.MakeDirty(AccountCodeTextBox);
            return;
        }
        else
        {
            MixERP.Net.BusinessLayer.Helpers.FormHelper.RemoveDirty(AccountCodeTextBox);
        }

        if(string.IsNullOrWhiteSpace(account))
        {
            MixERP.Net.BusinessLayer.Helpers.FormHelper.MakeDirty(AccountDropDownList);
            return;
        }
        else
        {
            MixERP.Net.BusinessLayer.Helpers.FormHelper.RemoveDirty(AccountDropDownList);
        }

        if(debit.Equals(0) && credit.Equals(0))
        {
            MixERP.Net.BusinessLayer.Helpers.FormHelper.MakeDirty(DebitTextBox);
            MixERP.Net.BusinessLayer.Helpers.FormHelper.MakeDirty(CreditTextBox);
            return;
        }
        else
        {
            if(debit > 0 && credit > 0)
            {
                MixERP.Net.BusinessLayer.Helpers.FormHelper.MakeDirty(DebitTextBox);
                MixERP.Net.BusinessLayer.Helpers.FormHelper.MakeDirty(CreditTextBox);
                return;
            }
            else
            {
                MixERP.Net.BusinessLayer.Helpers.FormHelper.RemoveDirty(StatementReferenceTextBox);
            }
        }

        if(MixERP.Net.BusinessLayer.Core.Accounts.IsCashAccount(accountCode))
        {
            if(string.IsNullOrEmpty(CashRepositoryDropDownList.SelectedItem.Value))
            {
                MixERP.Net.BusinessLayer.Helpers.FormHelper.MakeDirty(CashRepositoryDropDownList);
                CashRepositoryDropDownList.Focus();
                return;
            }
            else
            {
                MixERP.Net.BusinessLayer.Helpers.FormHelper.RemoveDirty(CashRepositoryDropDownList);
            }
        }

        using(System.Data.DataTable table = this.GetTable())
        {
            if(table.Rows.Count > 0)
            {
                foreach(System.Data.DataRow row in table.Rows)
                {
                    if(row[0].Equals(accountCode))
                    {
                        MixERP.Net.BusinessLayer.Helpers.FormHelper.MakeDirty(AccountCodeTextBox);
                        MixERP.Net.BusinessLayer.Helpers.FormHelper.MakeDirty(AccountDropDownList);
                        return;
                    }
                }
            }
        }

        #endregion

        this.AddRowToTable(accountCode, account, cashRepository, statementReference, debit, credit);
        this.BindGridView();
        DebitTextBox.Text = "";
        CreditTextBox.Text = "";
        AccountCodeTextBox.Focus();
    }


    private void DataBindControls()
    {
        using(System.Data.DataTable table = MixERP.Net.BusinessLayer.Helpers.FormHelper.GetTable("office", "cost_centers"))
        {
            table.Columns.Add("cost_center", typeof(string), MixERP.Net.BusinessLayer.Office.CostCenters.GetDisplayField());

            CostCenterDropDownList.DataSource = table;
            CostCenterDropDownList.DataValueField = "cost_center_id";
            CostCenterDropDownList.DataTextField = "cost_center";
            CostCenterDropDownList.DataBind();
        }
    }

    private void BindGridView()
    {
        using(System.Data.DataTable table = this.GetTable())
        {
            TransactionGridView.DataSource = table;
            TransactionGridView.DataBind();

            if(table.Rows.Count > 0)
            {
                decimal debit = 0;
                decimal credit = 0;

                foreach(System.Data.DataRow row in table.Rows)
                {
                    debit += Pes.Utility.Conversion.TryCastDecimal(row["Debit"]);
                    credit += Pes.Utility.Conversion.TryCastDecimal(row["Credit"]);
                }

                DebitTotalTextBox.Text = debit.ToString("G29");
                CreditTotalTextBox.Text = credit.ToString("G29");
            }
        }
    }

</script>
