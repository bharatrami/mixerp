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

namespace MixERP.net.FrontEnd.UserControls.Products
{
    public partial class ProductControl : System.Web.UI.UserControl
    {
        public enum TranType { Sales, Purchase }
        public TranType TransactionType { get; set; }
        public string Text { get; set; }
        public GridView Grid { get { return ProductGridView; } }
        public bool ShowTransactionType { get; set; }
        public bool VerifyStock { get; set; }
        public bool ShowCashRepository { get; set; }

        public ControlCollection GetForm
        {
            get
            {
                return this.GetControls();
            }
        }

        public class ControlCollection
        {
            public MixERP.net.FrontEnd.UserControls.DateTextBox DateTextBox { get; set; }
            public DropDownList StoreDropDownList { get; set; }
            public RadioButtonList TransactionTypeRadioButtonList { get; set; }
            public TextBox CustomerCodeTextBox { get; set; }
            public DropDownList CustomerDropDownList { get; set; }
            public TextBox SupplierCodeTextBox { get; set; }
            public DropDownList SupplierDropDownList { get; set; }
            public DropDownList PriceTypeDropDownList { get; set; }
            public GridView Grid { get; set; }
            public TextBox RunningTotalTextBox { get; set; }
            public TextBox TaxTotalTextBox { get; set; }
            public TextBox GrandTotalTextBox { get; set; }
            public DropDownList CashRepositoryDropDownList { get; set; }
            public TextBox CashRepositoryBalanceTextBox { get; set; }
            public DropDownList CostCenterDropDownList { get; set; }
            public TextBox StatementReferenceTextBox { get; set; }
        }

        private ControlCollection GetControls()
        {
            ControlCollection collection = new ControlCollection();
            collection.DateTextBox = this.DateTextBox;
            collection.StoreDropDownList = this.StoreDropDownList;
            collection.TransactionTypeRadioButtonList = this.TransactionTypeRadioButtonList;
            collection.CustomerCodeTextBox = this.CustomerCodeTextBox;
            collection.CustomerDropDownList = this.CustomerDropDownList;
            collection.SupplierCodeTextBox = this.SupplierCodeTextBox;
            collection.SupplierDropDownList = this.SupplierDropDownList;
            collection.PriceTypeDropDownList = this.PriceTypeDropDownList;
            collection.Grid = this.ProductGridView;
            collection.RunningTotalTextBox = this.RunningTotalTextBox;
            collection.TaxTotalTextBox = this.TaxTotalTextBox;
            collection.GrandTotalTextBox = this.GrandTotalTextBox;
            collection.CashRepositoryDropDownList = this.CashRepositoryDropDownList;
            collection.CashRepositoryBalanceTextBox = this.CashRepositoryBalanceTextBox;
            collection.CostCenterDropDownList = this.CostCenterDropDownList;
            collection.StatementReferenceTextBox = this.StatementReferenceTextBox;
            return collection;
        }


        public Unit TopPanelWidth
        {
            get
            {
                return this.TopPanel.Width;
            }
            set
            {
                this.TopPanel.Width = value;
            }

        }

        public event EventHandler SaveButtonClick;

        public virtual void OnSaveButtonClick(object sender, EventArgs e)
        {
            if(SaveButtonClick != null)
            {
                this.SaveButtonClick(sender, e);
            }
        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            //Validation Check Start
            if(ProductGridView.Rows.Count.Equals(0))
            {
                ErrorLabel.Text = Resources.Warnings.NoItemFound;
                return;
            }
            //Validation Check End

            //Now exposing the button click event.
            this.OnSaveButtonClick(sender, e);
        }

        protected void ProductGridView_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            using(System.Data.DataTable table = this.GetTable())
            {
                GridViewRow row = (GridViewRow)(((ImageButton)e.CommandSource).NamingContainer);
                int index = row.RowIndex;

                table.Rows.RemoveAt(index);
                Session[this.ID] = table;
                this.BindGridView();
                //UpdatePanel1.Update();
            }
        }

        protected void OrderGrid_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if(e.Row.RowType == DataControlRowType.DataRow)
            {
                ImageButton lb = e.Row.FindControl("DeleteImageButton") as ImageButton;
                ScriptManager.GetCurrent(this.Page).RegisterAsyncPostBackControl(lb);
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

            CostCenterDropDownList.DataSource = MixERP.net.BusinessLayer.Helper.FormHelper.GetTable("office", "cost_centers");
            CostCenterDropDownList.DataValueField = "cost_center_id";
            CostCenterDropDownList.DataTextField = "cost_center_name";
            CostCenterDropDownList.DataBind();

            StoreDropDownList.DataSource = MixERP.net.BusinessLayer.Helper.FormHelper.GetTable("office", "stores");
            StoreDropDownList.DataValueField = "store_id";
            StoreDropDownList.DataTextField = "store_name";
            StoreDropDownList.DataBind();


            ItemDropDownList.DataSource = MixERP.net.BusinessLayer.Helper.FormHelper.GetTable("core", "items");
            ItemDropDownList.DataBind();
            ItemDropDownList.Items.Insert(0, new ListItem("Select", ""));

            if(this.ShowCashRepository)
            {
                CashRepositoryDropDownList.DataSource = MixERP.net.BusinessLayer.Office.CashRepositories.GetCashRepositories(MixERP.net.BusinessLayer.Helper.SessionHelper.OfficeId());
                CashRepositoryDropDownList.DataBind();
                this.UpdateRepositoryBalance();
            }
            else
            {
                CashRepositoryRow.Visible = false;
                CashRepositoryBalanceRow.Visible = false;
            }

            this.BindGridView();
            ScriptManager1.RegisterAsyncPostBackControl(ProductGridView);
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if(Request.Form["__EVENTTARGET"] != null)
            {
                Control c = this.Page.FindControl(Request.Form["__EVENTTARGET"]);
                if(c != null)
                {
                    if(c.ID.Equals(UnitDropDownList.ClientID))
                    {
                        UnitDropDownList_SelectedIndexChanged(c, e);
                    }
                }
            }

            this.SetControlStates();
        }


        private void InitializeControls()
        {

            DateLiteral.Text = "<label for='DateTextBox'>" + Resources.Titles.ValueDate + "</label>";
            StoreLiteral.Text = "<label for='StoreDropDownList'>" + Resources.Titles.SelectStore + "</label>";
            CustomerLiteral.Text = "<label for='CustomerCodeTextBox'>" + Resources.Titles.SelectCustomer + "</label>";
            SupplierLiteral.Text = "<label for='SupplierCodeTextBox'>" + Resources.Titles.SelectSupplier + "</label>";
            PriceTypeLiteral.Text = "<label for='PriceTypeDropDownList'>" + Resources.Titles.PriceType + "</label>";

            RunningTotalTextBoxLabelLiteral.Text = "<label for ='RunningTotalTextBox'>" + Resources.Titles.RunningTotal + "</label>";
            TaxTotalTextBoxLabelLiteral.Text = "<label for='TaxTotalTextBox'>" + Resources.Titles.TaxTotal + "</label>";
            GrandTotalTextBoxLabelLiteral.Text = "<label for='GrandTotalTextBox'>" + Resources.Titles.GrandTotal + "</label>";
            CashRepositoryDropDownListLabelLiteral.Text = "<label for='CashRepositoryDropDownList'>" + Resources.Titles.CashRepository + "</label>";
            CashRepositoryBalanceTextBoxLabelLiteral.Text = "<label for='CashRepositoryBalanceTextBox'>" + Resources.Titles.CashRepositoryBalance + "</label>";
            CostCenterDropDownListLabelLiteral.Text = "<label for='CostCenterDropDownList'>" + Resources.Titles.CostCenter + "</label>";
            StatementReferenceTextBoxLabelLiteral.Text = "<label for='StatementReferenceTextBox'>" + Resources.Titles.StatementReference + "</label>";


            if(this.TransactionType == TranType.Sales)
            {
                TransactionTypeLiteral.Text = "<label>Sales Type</label>";
                SupplierLiteral.Visible = false;
                SupplierCodeTextBox.Visible = false;
                SupplierDropDownList.Visible = false;

                PriceTypeDropDownList.DataSource = MixERP.net.BusinessLayer.Helper.FormHelper.GetTable("core", "price_types");
                PriceTypeDropDownList.DataValueField = "price_type_id";
                PriceTypeDropDownList.DataTextField = "price_type_name";
                PriceTypeDropDownList.DataBind();

                CustomerDropDownList.DataSource = MixERP.net.BusinessLayer.Helper.FormHelper.GetTable("core", "customers");
                CustomerDropDownList.DataValueField = "customer_code";
                CustomerDropDownList.DataTextField = "customer_name";
                CustomerDropDownList.DataBind();
            }
            else
            {
                TransactionTypeLiteral.Text = "<label>Purchase Type</label>";
                CustomerLiteral.Visible = false;
                CustomerCodeTextBox.Visible = false;
                CustomerDropDownList.Visible = false;
                PriceTypeLiteral.Visible = false;
                PriceTypeDropDownList.Visible = false;

                SupplierDropDownList.DataSource = MixERP.net.BusinessLayer.Helper.FormHelper.GetTable("core", "suppliers");
                SupplierDropDownList.DataValueField = "supplier_code";
                SupplierDropDownList.DataTextField = "supplier_name";
                SupplierDropDownList.DataBind();
            }

            this.TitleLabel.Text = this.Text;
            TransactionTypeLiteral.Visible = this.ShowTransactionType;
            TransactionTypeRadioButtonList.Visible = this.ShowTransactionType;
        }


        private void BindGridView()
        {
            using(System.Data.DataTable table = this.GetTable())
            {
                ProductGridView.DataSource = table;
                ProductGridView.DataBind();

                try
                {
                    if(table.Rows.Count > 0)
                    {
                        RunningTotalTextBox.Text = this.GetRunningTotal(table, "SubTotal").ToString();
                        TaxTotalTextBox.Text = this.GetRunningTotal(table, "Tax").ToString();
                        GrandTotalTextBox.Text = this.GetRunningTotal(table, "Total").ToString();
                    }
                }
                catch
                {
                }
            }

        }

        private decimal GetRunningTotal(System.Data.DataTable table, string columnName)
        {
            decimal retVal = 0;

            if(table.Rows.Count > 0)
            {
                foreach(System.Data.DataRow row in table.Rows)
                {
                    retVal += Pes.Utility.Conversion.TryCastDecimal(row[columnName]);
                }
            }

            return retVal;
        }
        private void MakeDirty(WebControl c)
        {
            c.CssClass = "dirty";
            c.Focus();
        }

        private void RemoveDirty(WebControl c)
        {
            c.CssClass = "";
        }

        protected void CashRepositoryDropDownList_SelectIndexChanged(object sender, EventArgs e)
        {
            this.UpdateRepositoryBalance();
        }

        private void UpdateRepositoryBalance()
        {
            if(CashRepositoryBalanceRow.Visible)
            {
                if(CashRepositoryDropDownList.SelectedItem != null)
                {
                    CashRepositoryBalanceTextBox.Text = MixERP.net.BusinessLayer.Office.CashRepositories.GetBalance(Pes.Utility.Conversion.TryCastInteger(CashRepositoryDropDownList.SelectedItem.Value)).ToString();
                }
            }
        }

        protected void AddButton_Click(object sender, EventArgs e)
        {
            string itemCode = ItemCodeTextBox.Text;
            string itemName = ItemDropDownList.SelectedItem.Text;
            int quantity = Pes.Utility.Conversion.TryCastInteger(QuantityTextBox.Text);
            string unit = UnitDropDownList.SelectedItem.Text;
            int unitId = Pes.Utility.Conversion.TryCastInteger(UnitDropDownList.SelectedItem.Value);
            int itemInStock = 0;
            decimal price = Pes.Utility.Conversion.TryCastDecimal(PriceTextBox.Text);
            decimal discount = Pes.Utility.Conversion.TryCastDecimal(DiscountTextBox.Text);
            decimal taxRate = Pes.Utility.Conversion.TryCastDecimal(TaxRateTextBox.Text);
            decimal tax = Pes.Utility.Conversion.TryCastDecimal(TaxTextBox.Text);
            int storeId = Pes.Utility.Conversion.TryCastInteger(StoreDropDownList.SelectedItem.Value);

            #region Validation

            if(string.IsNullOrWhiteSpace(itemCode))
            {
                this.MakeDirty(ItemCodeTextBox);
                return;
            }
            else
            {
                this.RemoveDirty(ItemCodeTextBox);
            }

            if(!MixERP.net.BusinessLayer.Core.Items.ItemExistsByCode(itemCode))
            {
                this.MakeDirty(ItemCodeTextBox);
                return;
            }
            else
            {
                this.RemoveDirty(ItemCodeTextBox);
            }

            if(quantity < 1)
            {
                this.MakeDirty(QuantityTextBox);
                return;
            }
            else
            {
                this.RemoveDirty(QuantityTextBox);
            }

            if(!MixERP.net.BusinessLayer.Core.Units.UnitExistsByName(unit))
            {
                this.MakeDirty(UnitDropDownList);
                return;
            }
            else
            {
                this.RemoveDirty(UnitDropDownList);
            }

            if(price <= 0)
            {
                this.MakeDirty(PriceTextBox);
                return;
            }
            else
            {
                this.RemoveDirty(PriceTextBox);
            }

            if(discount < 0)
            {
                this.MakeDirty(DiscountTextBox);
                return;
            }
            else
            {
                if(discount > (price * quantity))
                {
                    this.MakeDirty(DiscountTextBox);
                    return;
                }
                else
                {
                    this.RemoveDirty(DiscountTextBox);
                }
            }


            if(tax < 0)
            {
                this.MakeDirty(TaxTextBox);
                return;
            }
            else
            {
                this.RemoveDirty(TaxTextBox);
            }

            if(this.VerifyStock)
            {
                if(this.TransactionType == TranType.Sales)
                {

                    itemInStock = MixERP.net.BusinessLayer.Core.Items.CountItemInStock(itemCode, unitId, storeId);
                    if(quantity > itemInStock)
                    {
                        this.MakeDirty(QuantityTextBox);
                        ErrorLabel.Text = String.Format(Resources.Warnings.InsufficientStockWarning.Replace("{ItemName}", "{0}").Replace("{Qty}", "{1}").Replace("{Unit}", "{2}"), ItemDropDownList.SelectedItem.Text, itemInStock.ToString(), UnitDropDownList.SelectedItem.Text);
                        return;
                    }
                }
            }
            #endregion

            this.AddRowToTable(itemCode, itemName, quantity, unit, price, discount, taxRate, tax);

            this.BindGridView();
            ItemCodeTextBox.Text = "";
            QuantityTextBox.Text = "1";
            PriceTextBox.Text = "";
            DiscountTextBox.Text = "";
            TaxTextBox.Text = "";

            ItemCodeTextBox.Focus();
        }

        private void AddRowToTable(string itemCode, string itemName, int quantity, string unit, decimal price, decimal discount, decimal taxRate, decimal tax)
        {
            using(System.Data.DataTable table = this.GetTable())
            {
                decimal amount = price * quantity;
                decimal subTotal = amount - discount;
                decimal total = subTotal + tax;

                System.Data.DataRow row = table.NewRow();
                row[0] = itemCode;
                row[1] = itemName;
                row[2] = quantity;
                row[3] = unit;
                row[4] = price;
                row[5] = amount;
                row[6] = discount;
                row[7] = subTotal;
                row[8] = taxRate;
                row[9] = tax;
                row[10] = total;

                table.Rows.Add(row);
                Session[this.ID] = table;
            }
        }

        private System.Data.DataTable GetTable()
        {
            if(Session[this.ID] != null)
            {
                return (System.Data.DataTable)Session[this.ID];
            }

            using(System.Data.DataTable table = new System.Data.DataTable())
            {
                table.Columns.Add("ItemCode");
                table.Columns.Add("ItemName");
                table.Columns.Add("Quantity");
                table.Columns.Add("Unit");
                table.Columns.Add("Price");
                table.Columns.Add("Amount");
                table.Columns.Add("Discount");
                table.Columns.Add("SubTotal");
                table.Columns.Add("Rate");
                table.Columns.Add("Tax");
                table.Columns.Add("Total");
                return table;
            }
        }

        void UnitDropDownList_SelectedIndexChanged(object sender, EventArgs e)
        {
            this.DisplayPrice();
            PriceTextBox.Focus();
        }

        private void DisplayPrice()
        {
            string itemCode = ItemDropDownList.SelectedItem.Value;
            string customer = string.Empty;
            string supplier = string.Empty;


            int unitId = Pes.Utility.Conversion.TryCastInteger(UnitDropDownList.SelectedItem.Value);

            decimal price = 0;

            if(this.TransactionType == TranType.Sales)
            {
                customer = CustomerDropDownList.SelectedItem.Value;
                short priceTypeId = Pes.Utility.Conversion.TryCastShort(PriceTypeDropDownList.SelectedItem.Value);
                price = MixERP.net.BusinessLayer.Core.Items.GetItemSellingPrice(itemCode, customer, priceTypeId, unitId);
            }
            else
            {
                supplier = SupplierDropDownList.SelectedItem.Value;
                price = MixERP.net.BusinessLayer.Core.Items.GetItemCostPrice(itemCode, supplier, unitId);
            }

            decimal discount = Pes.Utility.Conversion.TryCastDecimal(DiscountTextBox.Text);
            decimal taxRate = MixERP.net.BusinessLayer.Core.Items.GetTaxRate(itemCode);


            PriceTextBox.Text = price.ToString();

            TaxRateTextBox.Text = taxRate.ToString();
            TaxTextBox.Text = (((price - discount) * taxRate) / 100.00m).ToString("#.##");

            decimal amount = price * Pes.Utility.Conversion.TryCastInteger(QuantityTextBox.Text);

            AmountTextBox.Text = amount.ToString();
        }

        protected void OKButton_Click(object sender, EventArgs e)
        {
            DateTime valueDate = Pes.Utility.Conversion.TryCastDate(DateTextBox.Text);
            int storeId = Pes.Utility.Conversion.TryCastInteger(StoreDropDownList.SelectedItem.Value);
            string transactionType = TransactionTypeRadioButtonList.SelectedItem.Value;
            string customerCode = string.Empty;

            ErrorLabel.Text = "";

            if(valueDate.Equals(DateTime.MinValue))
            {
                ErrorLabelTop.Text = Resources.Warnings.InvalidDate;
                DateTextBox.CssClass = "dirty";
                DateTextBox.Focus();
                return;
            }

            if(this.TransactionType == TranType.Sales)
            {
                customerCode = CustomerDropDownList.SelectedItem.Value;

                if(!MixERP.net.BusinessLayer.Office.Stores.IsSalesAllowed(storeId))
                {
                    ErrorLabelTop.Text = Resources.Warnings.SalesNotAllowedHere;
                    this.MakeDirty(StoreDropDownList);
                    return;
                }

                if(transactionType.Equals(Resources.Titles.Credit))
                {
                    if(!MixERP.net.BusinessLayer.Core.Customers.IsCreditAllowed(customerCode))
                    {
                        ErrorLabelTop.Text = Resources.Warnings.CreditNotAllowed;
                        return;
                    }
                }
            }

            ModeHiddenField.Value = "Started";
            this.SetControlStates();
            ItemCodeTextBox.Focus();
        }

        protected void CancelButton_Click(object sender, EventArgs e)
        {
            ModeHiddenField.Value = "";

            Session[this.ID] = null;
            RunningTotalTextBox.Text = "";
            TaxTotalTextBox.Text = "";
            GrandTotalTextBox.Text = "";

            this.SetControlStates();
            this.BindGridView();
        }

        private void SetControlStates()
        {
            bool state = ModeHiddenField.Value.Equals("Started");

            FormPanel.Enabled = state;
            DateTextBox.Disabled = state;
            StoreDropDownList.Enabled = !state;
            TransactionTypeRadioButtonList.Enabled = !state;
            CustomerCodeTextBox.Enabled = !state;
            CustomerDropDownList.Enabled = !state;
            PriceTypeDropDownList.Enabled = !state;
            OKButton.Enabled = !state;
            CancelButton.Enabled = state;

            if(TransactionTypeRadioButtonList.Visible)
            {
                if(TransactionTypeRadioButtonList.SelectedItem.Value.Equals(Resources.Titles.Credit))
                {
                    CashRepositoryRow.Visible = false;
                    CashRepositoryBalanceRow.Visible = false;
                }
            }

        }
    }
}