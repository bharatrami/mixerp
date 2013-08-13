/********************************************************************************
Copyright (C) Binod Nepal, Mix Open Foundation (http://mixof.org).

This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. 
If a copy of the MPL was not distributed  with this file, You can obtain one at 
http://mozilla.org/MPL/2.0/.
***********************************************************************************/
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MixERP.Net.FrontEnd.Finance
{
    public partial class JournalVoucher : MixERP.Net.BusinessLayer.BasePageClass
    {
        protected void PostTransactionButton_Click(object sender, EventArgs e)
        {
            DateTime valueDate = Pes.Utility.Conversion.TryCastDate(ValueDateTextBox.Text);
            string referenceNumber = ReferenceNumberTextBox.Text;
            int costCenterId = Pes.Utility.Conversion.TryCastInteger(CostCenterDropDownList.SelectedItem.Value);

            long transactionId = MixERP.Net.BusinessLayer.Transactions.Transaction.Add(valueDate, referenceNumber, costCenterId, TransactionGridView);

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

    }
}