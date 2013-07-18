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
<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ProductControl.ascx.cs" Inherits="MixERP.net.FrontEnd.UserControls.Products.ProductControl" %>
<asp:ScriptManager ID="ScriptManager1" runat="server" />

<p>
    <h2>Direct Sales</h2>
</p>

<div class="form" style="width: 99%;">
    <table class="form-table">
        <tr>
            <td>
                <label for="TranIdTextBox">Tran Id</label>
            </td>
            <td>
                <label for="DateTextBox">Value Date</label>
            </td>
            <td>
                Types
            </td>
            <td>
                <label for="CustomerCodeTextBox">Select Customer</label>
            </td>
            <td>
                <asp:Literal ID="PriceTypeLiteral" runat="server" Text="<label for='PriceTypeDropDownList'>Price Type</label>" />
            </td>
            <td>
                <label for="CostCenterDropDownList">Cost Center</label>
            </td>
            <td>
                <label for="TaxFormDropDownList">Tax Form</label>
            </td>
            <td>
            </td>
        </tr>
        <tr>
            <td>
                <asp:TextBox ID="TranIdTextBox" runat="server" Width="30" Text="Auto" ReadOnly="true" />
            </td>
            <td>
                <pes:DateTextBox ID="DateTextBox" runat="server" />
            </td>

            <td>
                <asp:RadioButtonList ID="SalesTypeRadioButtonList" runat="server" RepeatDirection="Horizontal">
                    <asp:ListItem Text="Cash" Value="Cash" Selected="True" />
                    <asp:ListItem Text="Credit" Value="Cash" />
                </asp:RadioButtonList>
            </td>

            <td>
                <asp:TextBox ID="CustomerCodeTextBox" runat="server" Width="80" onblur="selectItem(this.id, 'CustomerDropDownList');" />
                <asp:DropDownList ID="CustomerDropDownList" runat="server" Width="150">
                </asp:DropDownList>
            </td>
            <td>
                <asp:DropDownList ID="PriceTypeDropDownList" runat="server" Width="80">
                </asp:DropDownList>
            </td>
            <td>
                <asp:DropDownList ID="CostCenterDropDownList" runat="server" Width="170">
                </asp:DropDownList>

            </td>
            <td>
                <asp:DropDownList ID="TaxFormDropDownList" runat="server" Width="70">
                </asp:DropDownList>
            </td>
            <td>
                <asp:Button ID="OKButton" runat="server" Text="OK" Width="30" OnClick="OKButton_Click" />
            </td>
        </tr>
    </table>
</div>


<p>
    <h3>Add Items</h3>
</p>
<asp:UpdateProgress ID="updProgress" runat="server">
    <ProgressTemplate>
        <div class="ajax-container">
            <img alt="progress" src="/spinner.gif" class="ajax-loader" />
        </div>
    </ProgressTemplate>
</asp:UpdateProgress>

<asp:UpdatePanel ID="UpdatePanel1" runat="server" ChildrenAsTriggers="true" UpdateMode="Conditional">
    <Triggers>
        <asp:AsyncPostBackTrigger ControlID="ProductGridView" />
    </Triggers>
    <ContentTemplate>
        <asp:Literal ID="TestLiteral" runat="server" />

        <asp:GridView ID="ProductGridView" runat="server" EnableTheming="False"
            CssClass="grid2"
            AlternatingRowStyle-CssClass="grid2-row-alt"
            OnRowDataBound="OrderGrid_RowDataBound"
            OnRowCommand="ProductGridView_RowCommand"
            AutoGenerateColumns="False">
            <Columns>
                <asp:BoundField DataField="Item Code" HeaderText="Item Code" />
                <asp:BoundField DataField="Item Name" HeaderText="Item Name" />
                <asp:BoundField DataField="Quantity" HeaderText="Quantity" ItemStyle-CssClass="right" HeaderStyle-CssClass="right"  />
                <asp:BoundField DataField="Unit" HeaderText="Unit" />
                <asp:BoundField DataField="Price" HeaderText="Price" ItemStyle-CssClass="right" HeaderStyle-CssClass="right" />
                <asp:BoundField DataField="Amount" HeaderText="Amount" ItemStyle-CssClass="right" HeaderStyle-CssClass="right"  />
                <asp:TemplateField ShowHeader="False">
                    <ItemTemplate>
                        <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="False" CommandName="Delete2" Text="Delete" OnClientClick="return(confirm('Are you sure?'));">
                        </asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <AlternatingRowStyle CssClass="grid2-row-alt" />
            <FooterStyle CssClass="grid2-footer" />
            <HeaderStyle CssClass="grid2-header" />
            <RowStyle CssClass="grid2-row" />
        </asp:GridView>
    </ContentTemplate>
</asp:UpdatePanel>

<script runat="server">
    public enum TranType { Sales, Purchase }
    public TranType TransactionType { get; set; }

    protected void ProductGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        using (System.Data.DataTable table = this.GetTable())
        {
            GridViewRow row = (GridViewRow)(((LinkButton)e.CommandSource).NamingContainer);
            int index = row.RowIndex;

            table.Rows.RemoveAt(index);
            Session[this.ID] = table;
            this.BindGridView();
            //UpdatePanel1.Update();
        }
    }

    protected void OrderGrid_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            LinkButton lb = e.Row.FindControl("LinkButton1") as LinkButton;
            ScriptManager.GetCurrent(this.Page).RegisterAsyncPostBackControl(lb);
        }
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        PriceTypeDropDownList.DataSource = MixERP.net.BusinessLayer.Helper.FormHelper.GetTable("core", "price_types");
        PriceTypeDropDownList.DataValueField = "price_type_id";
        PriceTypeDropDownList.DataTextField = "price_type_name";
        PriceTypeDropDownList.DataBind();

        CostCenterDropDownList.DataSource = MixERP.net.BusinessLayer.Helper.FormHelper.GetTable("office", "cost_centers");
        CostCenterDropDownList.DataValueField = "cost_center_id";
        CostCenterDropDownList.DataTextField = "cost_center_name";
        CostCenterDropDownList.DataBind();



        TaxFormDropDownList.DataSource = MixERP.net.BusinessLayer.Helper.FormHelper.GetTable("core", "tax_forms");
        TaxFormDropDownList.DataValueField = "tax_form_id";
        TaxFormDropDownList.DataTextField = "tax_form_code";
        TaxFormDropDownList.DataBind();

        CustomerDropDownList.DataSource = MixERP.net.BusinessLayer.Helper.FormHelper.GetTable("core", "customers");
        CustomerDropDownList.DataValueField = "customer_code";
        CustomerDropDownList.DataTextField = "customer_name";
        CustomerDropDownList.DataBind();

        this.BindGridView();
        ScriptManager1.RegisterAsyncPostBackControl(ProductGridView);
    }

    private void ProcessEmptyGrid(System.Data.DataTable table, GridView grid)
    {
        bool isEmpty = false;
        bool hasRow = false;

        if (table.Rows.Count.Equals(1))
        {
            if (string.IsNullOrWhiteSpace(table.Rows[0][0].ToString()))
            {
                isEmpty = true;
                hasRow = true;
            }
        }

        if (table.Rows.Count.Equals(0))
        {
            isEmpty = true;
        }

        if (isEmpty)
        {
            if (!hasRow)
            {
                table.Rows.Add(table.NewRow());
            }
        }

        grid.DataSource = table;
        grid.DataBind();

        if (isEmpty)
        {
            TableCell cell = new TableCell();
            cell.ColumnSpan = grid.Columns.Count;
            cell.Height = 0;
                
            grid.Rows[0].Cells.Clear();
            grid.Rows[0].Cells.Add(cell);

        }
    }

    private void BindGridView()
    {
        ProductGridView.ShowFooter = true;

        using (System.Data.DataTable table = this.GetTable())
        {
           ProcessEmptyGrid(table, ProductGridView);
        }

        GridViewRow footer = ProductGridView.FooterRow;

        TextBox itemCodeTextBox = new TextBox();
        itemCodeTextBox.ID = "ItemCodeTextBox";
        itemCodeTextBox.Attributes["onblur"] = "selectItem(this.id, 'ItemDropDownList');";
        itemCodeTextBox.Width = 60;
        footer.Cells[0].Controls.Add(itemCodeTextBox);

        DropDownList itemDropDownList = new DropDownList();

        itemDropDownList.ID = "ItemDropDownList";
        itemDropDownList.Width = 500;

        itemDropDownList.DataSource = MixERP.net.BusinessLayer.Helper.FormHelper.GetTable("core", "items");
        itemDropDownList.DataValueField = "item_code";
        itemDropDownList.DataTextField = "item_name";
        itemDropDownList.DataBind();

        itemDropDownList.Items.Insert(0, new ListItem("Select", ""));
        itemDropDownList.AutoPostBack = true;
        itemDropDownList.Attributes.Add("onchange", "document.getElementById('ItemCodeTextBox').value = this.options[this.selectedIndex].value;if(this.selectedIndex == 0)return false;");
        itemDropDownList.SelectedIndexChanged += ItemDropDownList_TextChanged;

        footer.Cells[1].Controls.Add(itemDropDownList);

        ScriptManager1.RegisterAsyncPostBackControl(itemDropDownList);

        TextBox quantityTextBox = new TextBox();
        quantityTextBox.ID = "QuantityTextBox";
        quantityTextBox.Attributes.Add("type", "number");
        quantityTextBox.Attributes.Add("onblur", "calculateAmount();");
        quantityTextBox.CssClass = "right";
        quantityTextBox.Width = 60;
        quantityTextBox.Text = "1";
        footer.Cells[2].Controls.Add(quantityTextBox);

        DropDownList unitDropDownList = new DropDownList();
        unitDropDownList.ID = "UnitDropDownList";
        unitDropDownList.Width = 70;

        unitDropDownList.AutoPostBack = true;
        unitDropDownList.SelectedIndexChanged += UnitDropDownList_SelectedIndexChanged;
        footer.Cells[3].Controls.Add(unitDropDownList);

        ScriptManager1.RegisterAsyncPostBackControl(unitDropDownList);

        TextBox priceTextBox = new TextBox();
        priceTextBox.ID = "PriceTextBox";
        priceTextBox.Width = 100;
        priceTextBox.CssClass = "right";

        footer.Cells[4].Controls.Add(priceTextBox);

        TextBox amountTextBox = new TextBox();
        amountTextBox.ID = "AmountTextBox";
        amountTextBox.Width = 100;
        amountTextBox.CssClass = "right";
        quantityTextBox.Attributes.Add("onblur", "calculateAmount();");
        amountTextBox.ReadOnly = true;

        footer.Cells[5].Controls.Add(amountTextBox);

        Button addButton = new Button();
        addButton.ID = "AddButton";
        addButton.CssClass = "button";
        addButton.Text = "Add";
        addButton.Width = 50;
        addButton.Click += AddButton_Click;
        footer.Cells[6].Controls.Add(addButton);

        ScriptManager1.RegisterAsyncPostBackControl(addButton);

    }

    protected void AddButton_Click(object sender, EventArgs e)
    {
        TextBox itemCodeTextBox = (TextBox)ProductGridView.FooterRow.FindControl("ItemCodeTextBox");
        DropDownList itemDropDownList = (DropDownList)ProductGridView.FooterRow.FindControl("ItemDropDownList");
        TextBox quantityTextBox = (TextBox)ProductGridView.FooterRow.FindControl("QuantityTextBox");
        DropDownList unitDropDownList = (DropDownList)ProductGridView.FooterRow.FindControl("UnitDropDownList");
        TextBox priceTextBox = (TextBox)ProductGridView.FooterRow.FindControl("PriceTextBox");


        if (Pes.Utility.Conversion.TryCastInteger(quantityTextBox.Text) < 1)
        {
            quantityTextBox.CssClass = "dirty";
            return;
        }
        

        System.Data.DataTable table = null;

        if (Session[this.ID] == null)
        {
            table = this.GetTable();
        }
        else
        {
            table = (System.Data.DataTable)Session[this.ID];
        }

        table = AddRowToTable(table, itemCodeTextBox.Text, itemDropDownList.SelectedItem.Text, Pes.Utility.Conversion.TryCastInteger(quantityTextBox.Text), unitDropDownList.SelectedItem.Text, Pes.Utility.Conversion.TryCastDecimal(priceTextBox.Text));
        Session[this.ID] = table;

        this.BindGridView();
        itemCodeTextBox.Focus();
    }

    private System.Data.DataTable AddRowToTable(System.Data.DataTable table, string itemCode, string itemName, int quantity, string unit, decimal price)
    {
        if (table.Rows.Count > 0)
        {
            if (string.IsNullOrWhiteSpace(table.Rows[0][0].ToString()))
            {
                table.Rows.RemoveAt(0);
            }
        }

        decimal amount = price * quantity;
        System.Data.DataRow row = table.NewRow();
        row[0] = itemCode;
        row[1] = itemName;
        row[2] = quantity;
        row[3] = unit;
        row[4] = price;
        row[5] = amount;

        table.Rows.Add(row);
        return table;
    }

    private System.Data.DataTable GetTable()
    {
        if (Session[this.ID] != null)
        {
            return (System.Data.DataTable)Session[this.ID];
        }

        using (System.Data.DataTable table = new System.Data.DataTable())
        {
            table.Columns.Add("Item Code");
            table.Columns.Add("Item Name");
            table.Columns.Add("Quantity");
            table.Columns.Add("Unit");
            table.Columns.Add("Price");
            table.Columns.Add("Amount");
            return table;
        }
    }

    protected void ItemDropDownList_TextChanged(object sender, EventArgs e)
    {
        this.BindUnitDropDownList();

        this.DisplayPrice();

        ((TextBox)ProductGridView.FooterRow.FindControl("QuantityTextBox")).Focus();
    }

    private void BindUnitDropDownList()
    {
        DropDownList unitDropDownList = (DropDownList)ProductGridView.FooterRow.FindControl("UnitDropDownList");
        unitDropDownList.DataSource = MixERP.net.BusinessLayer.Helper.FormHelper.GetTable("core", "units");
        unitDropDownList.DataValueField = "unit_id";
        unitDropDownList.DataTextField = "unit_name";
        unitDropDownList.DataBind();
        unitDropDownList.Items.Insert(0, new ListItem("Select", ""));
        unitDropDownList.SelectedIndex = 1;
    }

    void UnitDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        this.DisplayPrice();

        ((TextBox)ProductGridView.FooterRow.FindControl("PriceTextBox")).Focus();

        DropDownList unitDropDownList = (DropDownList)ProductGridView.FooterRow.FindControl("UnitDropDownList");
    }


    private void DisplayPrice()
    {
        DropDownList itemDropDownList = (DropDownList)ProductGridView.FooterRow.FindControl("ItemDropDownList");
        DropDownList unitDropDownList = (DropDownList)ProductGridView.FooterRow.FindControl("UnitDropDownList");
        TextBox itemCodeTextBox = (TextBox)ProductGridView.FooterRow.FindControl("ItemCodeTextBox");
        TextBox priceTextBox = (TextBox)ProductGridView.FooterRow.FindControl("PriceTextBox");

        TestLiteral.Text = itemCodeTextBox.Text + " / " + unitDropDownList.SelectedValue;

        string itemCode = itemDropDownList.SelectedItem.Value;
        int priceTypeId = Pes.Utility.Conversion.TryCastInteger(PriceTypeDropDownList.SelectedItem.Value);
        int unitId = Pes.Utility.Conversion.TryCastInteger(unitDropDownList.SelectedItem.Value);

        priceTextBox.Text = 5000.ToString();
    }

    protected void OKButton_Click(object sender, EventArgs e)
    {

    }

</script>


<script type="text/javascript">

    var selectItem = function (tb, ddl) {
        var listControl = $("#" + ddl);
        var textBox = $("#" + tb);
        var selectedValue = textBox.val();
        var exists;

        if (listControl.length) {
            listControl.find('option').each(function () {
                if (this.value == selectedValue) {
                    exists = true;
                }
            });
        }

        if (exists) {
            listControl.val(selectedValue);
        }
        else {
            textBox.val('');
        }

        listControl.change();
    }

    var calculateAmount = function () {
        var quantityTextBox = $("#QuantityTextBox");
        var priceTextBox = $("#PriceTextBox");
        var amountTextBox = $("#AmountTextBox");

        amountTextBox.val(quantityTextBox.val() * priceTextBox.val());
    }

    this.calculateAmount();
</script>
