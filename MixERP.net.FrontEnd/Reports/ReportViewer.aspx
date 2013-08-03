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

<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReportViewer.aspx.cs" Inherits="MixERP.Net.FrontEnd.Reports.ReportViewer" ValidateRequest="false" %>

<%@ Import Namespace="MixERP.Net.BusinessLayer.Helpers" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="/Scripts/jquery.min.js" type="text/javascript"></script>
</head>
<body>
    <form id="form1" runat="server">

    <asp:Panel runat="server" ID="ReportParameterPanel" class="report-parameter hide">
        <asp:Table ID="ReportParameterTable" runat="server" />
        <a href="#" onclick="$('.report-parameter').toggle(500);" class="menu" style="float: right; padding: 4px;">Close This Form</a>
    </asp:Panel>

    <pes:Report ID="ReportViewer1" runat="server" />
    </form>
</body>
</html>
<script runat="server">
    

    protected void Page_Init(object sender, EventArgs e)
    {
        this.AddParameters();
    }

    private void AddParameters()
    {
        System.Collections.ObjectModel.Collection<KeyValuePair<string, string>> collection = this.GetParameters();

        if(collection == null || collection.Count.Equals(0))
        {
            ReportParameterPanel.Style.Add("display", "none");
            ReportViewer1.ReportPath = this.ReportPath();
            ReportViewer1.InitializeReport();
            return;
        }

        foreach(KeyValuePair<string, string> parameter in collection)
        {
            TextBox textBox = new TextBox();
            textBox.ID = parameter.Key.Replace("@", "") + "_text_box";

            string label = "<label for='" + textBox.ID + "'>" + Pes.Utility.Helpers.LocalizationHelper.GetResourceString("FormResource", parameter.Key.Replace("@", "")) + "</label>";

            if(parameter.Value.Equals("Date"))
            {

            }
            else
            {

            }

            AddRow(label, textBox);
        }

        Button button = new Button();
        button.ID = "UpdateButton";
        button.Text = "Update";
        button.CssClass = "myButton";
        button.Click += button_Click;

        AddRow("", button);

    }

    protected void button_Click(object sender, EventArgs e)
    {
        if(ReportParameterTable.Rows.Count.Equals(0))
        {
            return;
        }

        System.Collections.ObjectModel.Collection<KeyValuePair<string, string>> list = new System.Collections.ObjectModel.Collection<KeyValuePair<string, string>>();

        foreach(TableRow row in ReportParameterTable.Rows)
        {
            TableCell cell = row.Cells[1];

            if(cell.Controls[0] is TextBox)
            {
                TextBox textBox = (TextBox)cell.Controls[0];
                list.Add(new KeyValuePair<string, string>("@" + textBox.ID.Replace("_text_box", ""), textBox.Text));
            }
        }
        ReportViewer1.ReportPath = this.ReportPath();
        ReportViewer1.Parameters = MixERP.Net.BusinessLayer.Helpers.ReportHelper.BindParameters(Server.MapPath(this.ReportPath()), list);
        ReportViewer1.InitializeReport();
    }

    private void AddRow(string label, Control control)
    {
        TableRow row = new TableRow();

        TableCell cell = new TableCell();
        cell.Text = label;

        TableCell controlCell = new TableCell();
        controlCell.Controls.Add(control);

        row.Cells.Add(cell);
        row.Cells.Add(controlCell);

        ReportParameterTable.Rows.Add(row);

    }

    private string ReportPath()
    {
        string id = this.Request["Id"];
        if(string.IsNullOrWhiteSpace(id))
        {
            return null;
        }

        return "~/Reports/Sources/" + id;
    }

    private System.Collections.ObjectModel.Collection<KeyValuePair<string, string>> GetParameters()
    {
        string path = Server.MapPath(this.ReportPath());
        System.Collections.ObjectModel.Collection<KeyValuePair<string, string>> collection = MixERP.Net.BusinessLayer.Helpers.ReportHelper.GetParameters(path);
        return collection;
    }

    
</script>
