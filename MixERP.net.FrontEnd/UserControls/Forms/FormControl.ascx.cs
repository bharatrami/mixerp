﻿/********************************************************************************
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
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace MixERP.net.FrontEnd.UserControls.Forms
{
    public partial class FormControl : System.Web.UI.UserControl
    {
        public bool DenyEdit { get; set; }
        public bool DenyDelete { get; set; }
        public bool DenyAdd { get; set; }
        public string DisplayFields { get; set; }
        public string Exclude { get; set; }
        public string KeyColumn { get; set; }
        public int PageSize { get; set; }
        public string SelectedValues { get; set; }
        public string Table { get; set; }
        public string TableSchema { get; set; }
        public string Text { get; set; }
        public string View { get; set; }
        public string ViewSchema { get; set; }
        public int Width { get; set; }

        protected void FormGridView_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                HtmlInputRadioButton radio = new HtmlInputRadioButton();
                radio.ClientIDMode = System.Web.UI.ClientIDMode.Static;
                radio.Name = "SelectRadio";
                radio.ID = "SelectRadio";
                radio.ClientIDMode = System.Web.UI.ClientIDMode.Predictable;
                radio.Value = e.Row.Cells[1].Text;
                radio.Attributes.Add("onclick", "selected(this.id);");
                e.Row.Cells[0].Controls.Add(radio);
            }
            else if (e.Row.RowType == DataControlRowType.Header)
            {
                for (int i = 0; i < e.Row.Cells.Count; i++)
                {
                    string cellText = e.Row.Cells[i].Text;
                    cellText = cellText.Replace("_", " ");

                    System.Globalization.TextInfo ti = new System.Globalization.CultureInfo("en-US", false).TextInfo;
                    cellText = ti.ToTitleCase(cellText);
                    e.Row.Cells[i].Text = cellText;
                }
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            TitleLabel.Text = this.Text;


            this.LoadGrid();

            this.LoadForm(this.FormContainer, new System.Data.DataTable());
        }

        private void LoadGrid()
        {
            bool showAll = (Pes.Utility.Conversion.TryCastString(Request.QueryString["show"]).Equals("all"));

            this.BindGridView();
            this.FormGridView.Width = this.Width;
            this.Pager.RecordCount = MixERP.net.BusinessLayer.Helper.FormHelper.GetTotalRecords(this.ViewSchema, this.View);
            this.Pager.PageSize = 10;


            if (this.PageSize != 0)
            {
                this.Pager.PageSize = this.PageSize;
            }

            if (showAll)
            {
                this.Pager.PageSize = 1000;
            }


            this.UserIdHidden.Value = Session["UserName"].ToString();
            this.OfficeCodeHidden.Value = Session["OfficeName"].ToString();
        }

        private void LoadForm(Panel container, System.Data.DataTable values)
        {
            HtmlTable t = new HtmlTable();

            using (System.Data.DataTable table = MixERP.net.BusinessLayer.Helper.TableHelper.GetTable(this.TableSchema, this.Table, this.Exclude))
            {
                if (table.Rows.Count > 0)
                {
                    foreach (System.Data.DataRow row in table.Rows)
                    {
                        string columnName = Pes.Utility.Conversion.TryCastString(row["column_name"]);
                        string defaultValue = Pes.Utility.Conversion.TryCastString(row["column_default"]); //nextval('core.menus_menu_id_seq'::regclass)
                        bool isSerial = defaultValue.StartsWith("nextval");
                        bool isNullable = Pes.Utility.Conversion.TryCastBoolean(row["is_nullable"]);
                        string dataType = Pes.Utility.Conversion.TryCastString(row["data_type"]);
                        int maxLength = Pes.Utility.Conversion.TryCastInteger(row["character_maximum_length"]);

                        string parentTableSchema = Pes.Utility.Conversion.TryCastString(row["references_schema"]);
                        string parentTable = Pes.Utility.Conversion.TryCastString(row["references_table"]);
                        string parentTableColumn = Pes.Utility.Conversion.TryCastString(row["references_field"]);

                        if (values.Rows.Count.Equals(1))
                        {
                            defaultValue = Pes.Utility.Conversion.TryCastString(values.Rows[0][columnName]);
                        }

                        this.AddField(t, columnName, defaultValue, isSerial, isNullable, dataType, maxLength, parentTableSchema, parentTable, parentTableColumn);
                    }
                }
            }

            container.Controls.Add(t);
        }

        protected void DeleteLinkButton_Click(object sender, EventArgs e)
        {
            string id = this.GetSelectedValue();
            if (string.IsNullOrWhiteSpace(id))
            {
                return;
            }

            if (DenyDelete)
            {
                FormLiteral.Text = "<p class='failure'>Could not delete the entry due to the following error:</p><hr class='hr' /><p class='failure'>Access is denied!</p>";
                return;
            }

            if (MixERP.net.BusinessLayer.Helper.FormHelper.DeleteRecord(this.TableSchema, this.Table, this.KeyColumn, id))
            {
                this.DisplaySuccess();
            }
        }

        protected void EditLinkButton_Click(object sender, EventArgs e)
        {
            string id = this.GetSelectedValue();
            if (string.IsNullOrWhiteSpace(id))
            {
                return;
            }

            using (System.Data.DataTable table = MixERP.net.BusinessLayer.Helper.FormHelper.GetTable(this.TableSchema, this.Table, this.KeyColumn, id))
            {
                if (table.Rows.Count.Equals(1))
                {
                    //Clear the form container.
                    FormContainer.Controls.Clear();

                    //Load the form again in the container with values 
                    //retrieved from database.
                    this.LoadForm(this.FormContainer, table);
                    GridPanel.Attributes["style"] = "display:none;";
                    FormPanel.Attributes["style"] = "display:block;";
                }
            }
        }

        private string GetSelectedValue()
        {
            foreach (GridViewRow row in FormGridView.Rows)
            {
                HtmlInputRadioButton r = (HtmlInputRadioButton)row.Controls[0].Controls[0];
                if (r.Checked)
                {
                    return r.Value;
                }
            }

            return string.Empty;
        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            List<KeyValuePair<string, string>> list = this.GetFormCollection(true);
            string id = this.GetSelectedValue();

            if (string.IsNullOrWhiteSpace(id))
            {
                if (DenyAdd)
                {
                    FormLiteral.Text = "<p class='failure'>Could not add the entry due to the following error:</p><hr class='hr' /><p class='failure'>Access is denied!</p>";
                }
                else
                {
                    if (MixERP.net.BusinessLayer.Helper.FormHelper.InsertRecord(this.TableSchema, this.Table, list))
                    {
                        this.DisplaySuccess();
                    }
                }
            }
            else
            {
                if (DenyEdit)
                {
                    FormLiteral.Text = "<p class='failure'>Could not edit the entry due to the following error:</p><hr class='hr' /><p class='failure'>Access is denied!</p>";
                }
                else
                {
                    if (MixERP.net.BusinessLayer.Helper.FormHelper.UpdateRecord(this.TableSchema, this.Table, list, this.KeyColumn, id))
                    {
                        this.DisplaySuccess();
                    }
                    else
                    {
                        FormLiteral.Text = "<p class='failure'>Could not complete the request due to an unknown error!</p>";
                    }
                }
            }
        }

        private void DisplaySuccess()
        {
            this.FormLiteral.Text = "<p class='success' style='text-align:left;'>Task completed successfully.</p>";
            this.LoadGrid();
            GridPanel.Attributes["style"] = "display:block;";
            FormPanel.Attributes["style"] = "display:none;";
            Response.Redirect(this.Page.Request.Url.AbsoluteUri);
        }

        private List<KeyValuePair<string, string>> GetFormCollection(bool skipSerial)
        {
            List<KeyValuePair<string, string>> list = new List<KeyValuePair<string, string>>();

            using (System.Data.DataTable table = MixERP.net.BusinessLayer.Helper.TableHelper.GetTable(this.TableSchema, this.Table, this.Exclude))
            {
                if (table.Rows.Count > 0)
                {
                    foreach (System.Data.DataRow row in table.Rows)
                    {
                        string columnName = Pes.Utility.Conversion.TryCastString(row["column_name"]);
                        string defaultValue = Pes.Utility.Conversion.TryCastString(row["column_default"]); //nextval('core.menus_menu_id_seq'::regclass)
                        bool isSerial = defaultValue.StartsWith("nextval");
                        string parentTableColumn = Pes.Utility.Conversion.TryCastString(row["references_field"]);
                        string dataType = Pes.Utility.Conversion.TryCastString(row["data_type"]);

                        if (skipSerial)
                        {
                            if (isSerial)
                            {
                                continue;
                            }
                        }

                        if (string.IsNullOrWhiteSpace(parentTableColumn))
                        {
                            switch (dataType)
                            {
                                case "national character varying":
                                case "character varying":
                                case "national character":
                                case "character":
                                case "char":
                                case "varchar":
                                case "nvarchar":
                                case "text":
                                case "date":
                                case "smallint":
                                case "integer":
                                case "bigint":
                                case "numeric":
                                case "money":
                                case "double":
                                case "double precision":
                                case "float":
                                case "real":
                                case "currency":
                                    //TextBox
                                    TextBox t = (TextBox)FormContainer.FindControl(columnName + "_textbox");
                                    if (t != null)
                                    {
                                        list.Add(new KeyValuePair<string, string>(columnName, t.Text));
                                    }
                                    break;
                                case "boolean":
                                    //RadioButtonList
                                    RadioButtonList r = (RadioButtonList)FormContainer.FindControl(columnName + "_radiobuttonlist");
                                    list.Add(new KeyValuePair<string, string>(columnName, r.Text));
                                    break;
                            }

                        }
                        else
                        {
                            //DropDownList
                            DropDownList d = (DropDownList)FormContainer.FindControl(columnName + "_dropdownlist");
                            list.Add(new KeyValuePair<string, string>(columnName, d.Text));
                        }
                    }
                }
            }

            return list;
        }

        private void AddField(HtmlTable t, string columnName, string defaultValue, bool isSerial, bool isNullable, string dataType, int maxLength, string parentTableSchema, string parentTable, string parentTableColumn)
        {
            if (string.IsNullOrWhiteSpace(parentTableColumn))
            {
                switch (dataType)
                {
                    case "national character varying":
                    case "character varying":
                    case "national character":
                    case "character":
                    case "char":
                    case "varchar":
                    case "nvarchar":
                    case "text":
                        this.AddTextBox(t, columnName, defaultValue, isNullable, maxLength);
                        break;
                    case "smallint":
                    case "integer":
                    case "bigint":
                        this.AddNumberTextBox(t, columnName, defaultValue, isSerial, isNullable, maxLength);
                        break;
                    case "numeric":
                    case "money":
                    case "double":
                    case "double precision":
                    case "float":
                    case "real":
                    case "currency":
                        this.AddDecimalTextBox(t, columnName, defaultValue, isNullable, maxLength);
                        break;
                    case "boolean":
                        this.AddRadioButtonList(t, columnName, isNullable, "Yes, No", "1, 0", defaultValue);
                        break;
                    case "date":
                        this.AddDateTextBox(t, columnName, defaultValue, isNullable, maxLength);
                        break;
                    case "timestamp with time zone":
                        //Do not show this field
                        break;
                }
            }
            else
            {
                this.AddDropDownList(t, columnName, isNullable, parentTableSchema, parentTable, parentTableColumn, defaultValue);
            }
        }

        private void AddDropDownList(HtmlTable t, string columnName, bool isNullable, string tableSchema, string tableName, string tableColumn, string defaultValue)
        {
            string selectedItemValue = string.Empty;
            string dataTextField = string.Empty;
            string relation = string.Empty;
            string field = string.Empty;
            string selected = string.Empty;

            DropDownList dropDownList = this.GetDropDownList(columnName + "_dropdownlist");


            using (System.Data.DataTable table = MixERP.net.BusinessLayer.Helper.FormHelper.GetTable(tableSchema, tableName))
            {
                if (table.Rows.Count > 0)
                {
                    //See DisplayFields Property for more information.
                    //Loop through all the DisplayFields to match this control.
                    foreach (string displayField in this.DisplayFields.Split(','))
                    {
                        //First, trim the field to remove whitespaces.
                        field = displayField.Trim();

                        //The fully qualified name of this column.
                        relation = tableSchema + "." + tableName + "." + tableColumn;

                        //Check whether this field matches exactly with this column.
                        if (field.StartsWith(relation))
                        {
                            //This field in this loop contained the column name we were looking for.
                            //Now, get the mapped column (display field) to show on the drop down list.
                            //This should be done by :
                            //1. Removing the column name from the field.
                            //2. Removign the the "-->" symbol.
                            //What we get is the name of the field that is displayed on this drop down list.
                            dataTextField = field.Replace(relation + "-->", "");

                            //Since we have found the field we needed, let's break this loop.
                            break;
                        }
                        //Probably this was not the field we were looking for.
                    }

                    //The display field can be an existing column or a representation of different columns (formula).
                    //Let's check whether the display field really exists.
                    if (!table.Columns.Contains(dataTextField))
                    {
                        //This display field was a formula based various columns.
                        //Now, we are adding a new column "DataTextField" in the data table using the requested formula.
                        table.Columns.Add("DataTextField", typeof(string), dataTextField);
                        dataTextField = "DataTextField";
                    }

                    dropDownList.DataSource = table;
                    dropDownList.DataValueField = tableColumn;
                    dropDownList.DataTextField = dataTextField;
                    dropDownList.DataBind();
                }
            }


            //Determining the value which will be pre-selected when this drop down list is displayed.

            //If the "defaultValue" parameter has a value, it means that the form is being edited.
            //Check if "defaultValue" is empty.
            if (!string.IsNullOrWhiteSpace(defaultValue))
            {
                selectedItemValue = defaultValue;
            }
            else
            {
                //In this case, this is probably a fresh form for entry.
                //Checking if the "SelectedValues" has a value.
                if (!string.IsNullOrWhiteSpace(this.SelectedValues))
                {
                    foreach (string selectedValue in this.SelectedValues.Split(','))
                    {
                        //Trim whitespaces
                        selected = selectedValue.Trim();

                        //The plain old fully qualified name of this column.
                        relation = tableSchema + "." + tableName + "." + tableColumn;

                        //Checking again whether this field matches exactly with this column.
                        if (selected.StartsWith(relation))
                        {
                            //This field in this loop contained the column name we were looking for.
                            //Now, get the mapped column (display field) to show on the drop down list.
                            //This should be done by :
                            //1. Removing the column name from the field.
                            //2. Removign the the "-->" symbol.
                            string value = selected.Replace(relation + "-->", "");

                            //Check the type of the value.
                            //If the value starts with single inverted comma, the value is a text.
                            if (value.StartsWith("'"))
                            {
                                //The selected item value from the drop down list text fields.
                                ListItem item = dropDownList.Items.FindByText(value.Replace("'", ""));

                                if (item != null)
                                {
                                    selectedItemValue = item.Value;
                                }
                            }
                            else
                            {
                                selectedItemValue = value;
                            }
                            break;
                        }
                    }
                }
            }


            if (!string.IsNullOrWhiteSpace(selectedItemValue))
            {
                dropDownList.SelectedValue = selectedItemValue;
            }

            if (isNullable)
            {
                dropDownList.Items.Insert(0, new ListItem(String.Empty, String.Empty));
                AddRow(t, columnName, dropDownList);
            }
            else
            {
                RequiredFieldValidator required = GetRequiredFieldValidator(dropDownList);
                AddRow(t, columnName + " *", dropDownList, required);
            }

        }


        private void AddRadioButtonList(HtmlTable t, string columnName, bool isNullable, string keys, string values, string selectedValue)
        {
            RadioButtonList radioButtonList = this.GetRadioButtonList(columnName + "_radiobuttonlist", keys, values, selectedValue);

            if (!isNullable)
            {
                RequiredFieldValidator required = GetRequiredFieldValidator(radioButtonList);
                AddRow(t, columnName + " *", radioButtonList, required);
                return;
            }

            AddRow(t, columnName, radioButtonList);
        }

        private void AddCheckBoxList(HtmlTable t, string columnName, bool isNullable, string keys, string values, string selectedValues)
        {
            CheckBoxList checkBoxList = this.GetCheckBoxList(columnName + "_radiobuttonlist", keys, values, selectedValues);

            if (!isNullable)
            {
                RequiredFieldValidator required = GetRequiredFieldValidator(checkBoxList);
                AddRow(t, columnName + " *", checkBoxList, required);
                return;
            }

            AddRow(t, columnName, checkBoxList);
        }

        private void AddNumberTextBox(HtmlTable t, string columnName, string defaultValue, bool isSerial, bool isNullable, int maxLength)
        {
            TextBox textBox = this.GetNumberTextBox(columnName + "_textbox", maxLength);
            CompareValidator validator = this.GetNumericalValidator(textBox);

            if (!defaultValue.StartsWith("nextVal"))
            {
                textBox.Text = defaultValue;
            }

            if (isSerial)
            {
                textBox.ReadOnly = true;
                textBox.Width = 100;
                //textBox.Text = "0";
            }
            else
            {
                if (!isNullable)
                {
                    RequiredFieldValidator required = GetRequiredFieldValidator(textBox);
                    AddRow(t, columnName + " *", textBox, validator, required);
                    return;
                }
            }

            AddRow(t, columnName, textBox, validator);
        }

        private void AddDecimalTextBox(HtmlTable t, string columnName, string defaultValue, bool isNullable, int maxLength)
        {
            TextBox textBox = this.GetTextBox(columnName + "_textbox", maxLength);
            CompareValidator validator = this.GetDecimalValidator(textBox);
            textBox.Text = defaultValue;

            if (!isNullable)
            {
                RequiredFieldValidator required = GetRequiredFieldValidator(textBox);
                AddRow(t, columnName + " *", textBox, validator, required);
                return;
            }

            AddRow(t, columnName, textBox, validator);
        }

        private void AddDateTextBox(HtmlTable t, string columnName, string defaultValue, bool isNullable, int maxLength)
        {
            TextBox textBox = this.GetTextBox(columnName + "_textbox", maxLength);
            CompareValidator validator = this.GetDateValidator(textBox);

            if (!string.IsNullOrWhiteSpace(defaultValue))
            {
                textBox.Text = Pes.Utility.Conversion.TryCastDate(defaultValue).ToShortDateString();
            }


            if (!isNullable)
            {
                RequiredFieldValidator required = GetRequiredFieldValidator(textBox);
                AddRow(t, columnName + " *", textBox, validator, required);
                return;
            }

            AddRow(t, columnName, textBox, validator);
        }

        private void AddTextBox(HtmlTable t, string columnName, string defaultValue, bool isNullable, int maxLength)
        {
            TextBox textBox = this.GetTextBox(columnName + "_textbox", maxLength);
            textBox.Text = defaultValue;

            if (!isNullable)
            {
                RequiredFieldValidator required = GetRequiredFieldValidator(textBox);
                AddRow(t, columnName + " *", textBox, required);
                return;
            }

            AddRow(t, columnName, textBox);
        }


        private CheckBoxList GetCheckBoxList(string id, string keys, string values, string selectedValues)
        {
            CheckBoxList list = new CheckBoxList();
            list.ID = id;
            list.ClientIDMode = System.Web.UI.ClientIDMode.Static;

            list.RepeatDirection = RepeatDirection.Horizontal;
            AddListItems(list, keys, values, selectedValues);
            return list;
        }

        private RadioButtonList GetRadioButtonList(string id, string keys, string values, string selectedValues)
        {
            RadioButtonList list = new RadioButtonList();
            list.ID = id;
            list.ClientIDMode = System.Web.UI.ClientIDMode.Static;

            list.RepeatDirection = RepeatDirection.Horizontal;
            AddListItems(list, keys, values, selectedValues);
            return list;
        }

        private DropDownList GetDropDownList(string id, string keys, string values, string selectedValues)
        {
            DropDownList list = new DropDownList();
            list.ID = id;
            list.ClientIDMode = System.Web.UI.ClientIDMode.Static;

            AddListItems(list, keys, values, selectedValues);
            return list;
        }

        private void AddListItems(ListControl control, string keys, string values, string selectedValues)
        {
            string[] key = keys.Split(',');
            string[] value = values.Split(',');

            if (key.Count() == value.Count())
            {
                for (int i = 0; i < key.Length; i++)
                {
                    ListItem item = new ListItem(key[i].Trim(), value[i].Trim());
                    control.Items.Add(item);
                }
            }

            foreach (ListItem item in control.Items)
            {
                if (control is CheckBoxList)
                {
                    foreach (string selectedValue in selectedValues.Split(','))
                    {
                        if (item.Value.Trim().Equals(selectedValue.Trim()))
                        {
                            item.Selected = true;
                        }
                    }
                }
                else
                {
                    if (item.Value.Trim().Equals(selectedValues.Split(',').Last().Trim()))
                    {
                        item.Selected = true;
                        break;
                    }
                }
            }
        }

        private DropDownList GetDropDownList(string id)
        {
            DropDownList dropDownList = new DropDownList();
            dropDownList.ID = id;

            dropDownList.ClientIDMode = System.Web.UI.ClientIDMode.Static;

            return dropDownList;
        }


        private TextBox GetTextBox(string id, int maxLength)
        {
            TextBox textBox = new TextBox();
            textBox.ID = id;

            if (!maxLength.Equals(int.MinValue))
            {
                textBox.MaxLength = maxLength;
            }

            textBox.ClientIDMode = System.Web.UI.ClientIDMode.Static;

            return textBox;
        }

        private TextBox GetNumberTextBox(string id, int maxLength)
        {
            TextBox textBox = this.GetTextBox(id, maxLength);
            textBox.Attributes["type"] = "number";
            return textBox;
        }

        private TextBox GetDateTextBox(string id, int maxLength)
        {
            TextBox textBox = this.GetTextBox(id, maxLength);
            textBox.Attributes["type"] = "date";
            return textBox;
        }

        private CompareValidator GetDateValidator(Control controlToValidate)
        {
            CompareValidator validator = new CompareValidator();
            validator.ID = controlToValidate.ID + "DateValidator";
            validator.ErrorMessage = "<br/>This is not a valid date.";
            validator.CssClass = "form-error";
            validator.ControlToValidate = controlToValidate.ID;
            validator.EnableClientScript = true;
            validator.SetFocusOnError = true;
            validator.Display = ValidatorDisplay.Dynamic;
            validator.Type = ValidationDataType.Date;
            validator.Operator = ValidationCompareOperator.GreaterThan;
            validator.ValueToCompare = "1-1-1900";

            return validator;
        }


        private CompareValidator GetDecimalValidator(Control controlToValidate)
        {
            CompareValidator validator = new CompareValidator();
            validator.ID = controlToValidate.ID + "DecimalValidator";
            validator.ErrorMessage = "<br/>Only numbers are allowed.";
            validator.CssClass = "form-error";
            validator.ControlToValidate = controlToValidate.ID;
            validator.EnableClientScript = true;
            validator.SetFocusOnError = true;
            validator.Display = ValidatorDisplay.Dynamic;
            validator.Type = ValidationDataType.Double;
            validator.Operator = ValidationCompareOperator.GreaterThanEqual;
            validator.ValueToCompare = "0";

            return validator;
        }

        private CompareValidator GetNumericalValidator(Control controlToValidate)
        {
            CompareValidator validator = new CompareValidator();
            validator.ID = controlToValidate.ID + "NumberValidator";
            validator.ErrorMessage = "<br/>Only numbers are allowed. Decimals not allowed.";
            validator.CssClass = "form-error";
            validator.ControlToValidate = controlToValidate.ID;
            validator.EnableClientScript = true;
            validator.SetFocusOnError = true;
            validator.Display = ValidatorDisplay.Dynamic;
            validator.Type = ValidationDataType.Integer;
            validator.Operator = ValidationCompareOperator.GreaterThanEqual;
            validator.ValueToCompare = "0";

            return validator;
        }

        private RequiredFieldValidator GetRequiredFieldValidator(Control controlToValidate)
        {
            RequiredFieldValidator validator = new RequiredFieldValidator();
            validator.ID = controlToValidate.ID + "RequiredValidator";
            validator.ErrorMessage = "<br/>This is a required field.";
            validator.CssClass = "form-error";
            validator.ControlToValidate = controlToValidate.ID;
            validator.EnableClientScript = true;
            validator.SetFocusOnError = true;
            validator.Display = ValidatorDisplay.Dynamic;

            return validator;
        }

        private void AddRow(HtmlTable table, string label, params Control[] controls)
        {
            HtmlTableRow newRow = new HtmlTableRow();
            HtmlTableCell labelCell = new HtmlTableCell();
            HtmlTableCell controlCell = new HtmlTableCell();
            Literal labelLiteral = new Literal();

            label = label.Replace("_", " ");

            System.Globalization.TextInfo ti = new System.Globalization.CultureInfo("en-US", false).TextInfo;
            label = ti.ToTitleCase(label);

            labelLiteral.Text = string.Format("<label for='{0}'>{1}</label>", controls[0].ID, label);
            labelCell.Attributes.Add("class", "label-cell");

            labelCell.Controls.Add(labelLiteral);

            foreach (Control control in controls)
            {
                controlCell.Controls.Add(control);
            }

            newRow.Cells.Add(labelCell);
            newRow.Cells.Add(controlCell);
            table.Rows.Add(newRow);
        }



        private void BindGridView()
        {
            bool showAll = (Pes.Utility.Conversion.TryCastString(Request.QueryString["show"]).Equals("all"));

            int limit = 10;
            int offset = 0;

            if (this.PageSize != 0)
            {
                limit = this.PageSize;
            }

            if (showAll)
            {
                limit = 1000;
            }

            if (this.Page.Request["page"] != null)
            {
                offset = (Pes.Utility.Conversion.TryCastInteger(this.Page.Request["page"]) - 1) * limit;
            }


            using (System.Data.DataTable table = MixERP.net.BusinessLayer.Helper.FormHelper.GetView(this.ViewSchema, this.View, this.KeyColumn, limit, offset))
            {
                if (table.Rows.Count > 0)
                {
                    this.FormGridView.DataSource = table;
                    this.FormGridView.DataBind();
                }
            }
        }

    }
}