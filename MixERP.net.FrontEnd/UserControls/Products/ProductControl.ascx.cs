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
using Microsoft.VisualBasic;

namespace MixERP.Net.FrontEnd.UserControls.Products
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
            public MixERP.Net.FrontEnd.UserControls.DateTextBox DateTextBox { get; set; }
            public DropDownList StoreDropDownList { get; set; }
            public RadioButtonList TransactionTypeRadioButtonList { get; set; }
            public TextBox PartyCodeTextBox { get; set; }
            public DropDownList PartyDropDownList { get; set; }
            public DropDownList PriceTypeDropDownList { get; set; }
            public GridView Grid { get; set; }
            public TextBox RunningTotalTextBox { get; set; }
            public TextBox TaxTotalTextBox { get; set; }
            public TextBox GrandTotalTextBox { get; set; }
            public DropDownList ShippingCompanyDropDownList { get; set; }
            public TextBox ShippingChargeTextBox { get; set; }
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
            collection.PartyCodeTextBox = this.PartyCodeTextBox;
            collection.PartyDropDownList = this.PartyDropDownList;
            collection.PriceTypeDropDownList = this.PriceTypeDropDownList;
            collection.Grid = this.ProductGridView;
            collection.RunningTotalTextBox = this.RunningTotalTextBox;
            collection.TaxTotalTextBox = this.TaxTotalTextBox;
            collection.GrandTotalTextBox = this.GrandTotalTextBox;
            collection.ShippingCompanyDropDownList = this.ShippingCompanyDropDownList;
            collection.ShippingChargeTextBox = this.ShippingChargeTextBox;
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

            if(!string.IsNullOrWhiteSpace(ShippingChargeTextBox.Text))
            {
                if(!Information.IsNumeric(ShippingChargeTextBox.Text))
                {
                    this.MakeDirty(ShippingChargeTextBox);
                    return;
                }
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

            ShippingCompanyDropDownList.DataSource = MixERP.Net.BusinessLayer.Helpers.FormHelper.GetTable("core", "shippers");
            ShippingCompanyDropDownList.DataValueField = "shipper_id";
            ShippingCompanyDropDownList.DataTextField = "company_name";
            ShippingCompanyDropDownList.DataBind();


            CostCenterDropDownList.DataSource = MixERP.Net.BusinessLayer.Helpers.FormHelper.GetTable("office", "cost_centers");
            CostCenterDropDownList.DataValueField = "cost_center_id";
            CostCenterDropDownList.DataTextField = "cost_center_name";
            CostCenterDropDownList.DataBind();

            StoreDropDownList.DataSource = MixERP.Net.BusinessLayer.Helpers.FormHelper.GetTable("office", "stores");
            StoreDropDownList.DataValueField = "store_id";
            StoreDropDownList.DataTextField = "store_name";
            StoreDropDownList.DataBind();


            ItemDropDownList.DataSource = MixERP.Net.BusinessLayer.Helpers.FormHelper.GetTable("core", "items");
            ItemDropDownList.DataBind();
            ItemDropDownList.Items.Insert(0, new ListItem(Resources.Titles.Select, ""));

            if(this.ShowCashRepository)
            {
                CashRepositoryDropDownList.DataSource = MixERP.Net.BusinessLayer.Office.CashRepositories.GetCashRepositories(MixERP.Net.BusinessLayer.Helpers.SessionHelper.OfficeId());
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

            PartyLiteral.Text = "<label for='PartyCodeTextBox'>" + Resources.Titles.SelectParty + "</label>";
            PriceTypeLiteral.Text = "<label for='PriceTypeDropDownList'>" + Resources.Titles.PriceType + "</label>";

            RunningTotalTextBoxLabelLiteral.Text = "<label for ='RunningTotalTextBox'>" + Resources.Titles.RunningTotal + "</label>";
            TaxTotalTextBoxLabelLiteral.Text = "<label for='TaxTotalTextBox'>" + Resources.Titles.TaxTotal + "</label>";
            GrandTotalTextBoxLabelLiteral.Text = "<label for='GrandTotalTextBox'>" + Resources.Titles.GrandTotal + "</label>";
            ShippingCompanyDropDownListLabelLiteral.Text = "<label for='ShippingCompanyDropDownList'>" + Resources.Titles.ShippingCompany + "</label>";
            ShippingChargeTextBoxLabelLiteral.Text = "<label for='ShippingChargeTextBox'>" + Resources.Titles.ShippingCharge + "</label>";
            CashRepositoryDropDownListLabelLiteral.Text = "<label for='CashRepositoryDropDownList'>" + Resources.Titles.CashRepository + "</label>";
            CashRepositoryBalanceTextBoxLabelLiteral.Text = "<label for='CashRepositoryBalanceTextBox'>" + Resources.Titles.CashRepositoryBalance + "</label>";
            CostCenterDropDownListLabelLiteral.Text = "<label for='CostCenterDropDownList'>" + Resources.Titles.CostCenter + "</label>";
            StatementReferenceTextBoxLabelLiteral.Text = "<label for='StatementReferenceTextBox'>" + Resources.Titles.StatementReference + "</label>";


            if(this.TransactionType == TranType.Sales)
            {
                TransactionTypeLiteral.Text = "<label>Sales Type</label>";

                PriceTypeDropDownList.DataSource = MixERP.Net.BusinessLayer.Helpers.FormHelper.GetTable("core", "price_types");
                PriceTypeDropDownList.DataValueField = "price_type_id";
                PriceTypeDropDownList.DataTextField = "price_type_name";
                PriceTypeDropDownList.DataBind();

                if(MixERP.Net.BusinessLayer.Core.Switches.AllowSupplierInSales())
                {
                    //This indicates that the admin has chosen to perform sales transaction 
                    //with suppliers as well.
                    PartyDropDownList.DataSource = MixERP.Net.BusinessLayer.Helpers.FormHelper.GetTable("core", "parties");
                }
                else
                {
                    PartyDropDownList.DataSource = MixERP.Net.BusinessLayer.Helpers.FormHelper.GetTable("core", "customer_view");
                }

                PartyDropDownList.DataValueField = "party_code";
                PartyDropDownList.DataTextField = "party_name";
                PartyDropDownList.DataBind();
            }
            else
            {
                TransactionTypeLiteral.Text = "<label>Purchase Type</label>";

                PriceTypeLiteral.Visible = false;
                PriceTypeDropDownList.Visible = false;


                if(MixERP.Net.BusinessLayer.Core.Switches.AllowNonSupplierInPurchase())
                {
                    //This indicates that the admin has chosen to perform purchase transaction 
                    //with non suppliers or customers.
                    PartyDropDownList.DataSource = MixERP.Net.BusinessLayer.Helpers.FormHelper.GetTable("core", "parties");
                }
                else
                {
                    PartyDropDownList.DataSource = MixERP.Net.BusinessLayer.Helpers.FormHelper.GetTable("core", "supplier_view");
                }

                PartyDropDownList.DataValueField = "party_code";
                PartyDropDownList.DataTextField = "party_name";
                PartyDropDownList.DataBind();
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
            }

            this.ShowTotals();
        }

        protected void ShippingChargeTextBox_TextChanged(object sender, EventArgs e)
        {
            this.ShowTotals();
        }

        private void ShowTotals()
        {
            using(System.Data.DataTable table = this.GetTable())
            {
                RunningTotalTextBox.Text = (this.GetRunningTotal(table, "SubTotal") + Pes.Utility.Conversion.TryCastDecimal(ShippingChargeTextBox.Text)).ToString(MixERP.Net.BusinessLayer.Helpers.SessionHelper.Culture());
                TaxTotalTextBox.Text = this.GetRunningTotal(table, "Tax").ToString(MixERP.Net.BusinessLayer.Helpers.SessionHelper.Culture());
                GrandTotalTextBox.Text = (this.GetRunningTotal(table, "Total") + Pes.Utility.Conversion.TryCastDecimal(ShippingChargeTextBox.Text)).ToString(MixERP.Net.BusinessLayer.Helpers.SessionHelper.Culture());
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
                    CashRepositoryBalanceTextBox.Text = MixERP.Net.BusinessLayer.Office.CashRepositories.GetBalance(Pes.Utility.Conversion.TryCastInteger(CashRepositoryDropDownList.SelectedItem.Value)).ToString(MixERP.Net.BusinessLayer.Helpers.SessionHelper.Culture());
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

            if(!MixERP.Net.BusinessLayer.Core.Items.ItemExistsByCode(itemCode))
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

            if(!MixERP.Net.BusinessLayer.Core.Units.UnitExistsByName(unit))
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

                    itemInStock = MixERP.Net.BusinessLayer.Core.Items.CountItemInStock(itemCode, unitId, storeId);
                    if(quantity > itemInStock)
                    {
                        this.MakeDirty(QuantityTextBox);
                        ErrorLabel.Text = String.Format(MixERP.Net.BusinessLayer.Helpers.SessionHelper.Culture(), Resources.Warnings.InsufficientStockWarning, itemInStock.ToString(MixERP.Net.BusinessLayer.Helpers.SessionHelper.Culture()), UnitDropDownList.SelectedItem.Text, ItemDropDownList.SelectedItem.Text);
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
                table.Locale = MixERP.Net.BusinessLayer.Helpers.SessionHelper.Culture();

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
            string party = string.Empty;

            int unitId = Pes.Utility.Conversion.TryCastInteger(UnitDropDownList.SelectedItem.Value);

            decimal price = 0;

            if(this.TransactionType == TranType.Sales)
            {
                party = PartyDropDownList.SelectedItem.Value;
                short priceTypeId = Pes.Utility.Conversion.TryCastShort(PriceTypeDropDownList.SelectedItem.Value);
                price = MixERP.Net.BusinessLayer.Core.Items.GetItemSellingPrice(itemCode, party, priceTypeId, unitId);
            }
            else
            {
                party = PartyDropDownList.SelectedItem.Value;
                price = MixERP.Net.BusinessLayer.Core.Items.GetItemCostPrice(itemCode, party, unitId);
            }

            decimal discount = Pes.Utility.Conversion.TryCastDecimal(DiscountTextBox.Text);
            decimal taxRate = MixERP.Net.BusinessLayer.Core.Items.GetTaxRate(itemCode);


            PriceTextBox.Text = price.ToString(MixERP.Net.BusinessLayer.Helpers.SessionHelper.Culture());

            TaxRateTextBox.Text = taxRate.ToString(MixERP.Net.BusinessLayer.Helpers.SessionHelper.Culture());
            TaxTextBox.Text = (((price - discount) * taxRate) / 100.00m).ToString("#.##", MixERP.Net.BusinessLayer.Helpers.SessionHelper.Culture());

            decimal amount = price * Pes.Utility.Conversion.TryCastInteger(QuantityTextBox.Text);

            AmountTextBox.Text = amount.ToString(MixERP.Net.BusinessLayer.Helpers.SessionHelper.Culture());
        }

        protected void OKButton_Click(object sender, EventArgs e)
        {
            DateTime valueDate = Pes.Utility.Conversion.TryCastDate(DateTextBox.Text);
            int storeId = Pes.Utility.Conversion.TryCastInteger(StoreDropDownList.SelectedItem.Value);
            string transactionType = TransactionTypeRadioButtonList.SelectedItem.Value;
            string partyCode = string.Empty;

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
                partyCode = PartyDropDownList.SelectedItem.Value;

                if(!MixERP.Net.BusinessLayer.Office.Stores.IsSalesAllowed(storeId))
                {
                    ErrorLabelTop.Text = Resources.Warnings.SalesNotAllowedHere;
                    this.MakeDirty(StoreDropDownList);
                    return;
                }

                if(transactionType.Equals(Resources.Titles.Credit))
                {
                    if(!MixERP.Net.BusinessLayer.Core.Parties.IsCreditAllowed(partyCode))
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
            PartyCodeTextBox.Enabled = !state;
            PartyDropDownList.Enabled = !state;
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