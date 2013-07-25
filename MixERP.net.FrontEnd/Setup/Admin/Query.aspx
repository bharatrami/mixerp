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

<%@ Page Title="" Language="C#" MasterPageFile="~/MenuMaster.Master" AutoEventWireup="true"
    CodeBehind="Query.aspx.cs" Inherits="MixERP.net.FrontEnd.Setup.Admin.Query" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ScriptContentPlaceHolder" runat="server">
    <script src="/Scripts/CodeMirror/lib/codemirror.js"></script>
    <script src="/Scripts/CodeMirror/mode/sql/sql.js"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="StyleSheetContentPlaceHolder" runat="server">
    <link href="/Scripts/CodeMirror/lib/codemirror.css" rel="stylesheet" />
    <link href="/Scripts/CodeMirror/theme/visual-studio.css" rel="stylesheet" />

    <style type="text/css">
        .CodeMirror
        {
            border: 1px solid #eee;
            height: auto;
        }

        .CodeMirror-scroll
        {
            overflow-y: hidden;
            overflow-x: auto;
        }
    </style>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="BodyContentPlaceHolder" runat="server">
    <div id="buttons">

        <asp:Button ID="ExecuteButton" runat="server" Text="Execute" OnClick="ExecuteButton_Click" />
        <asp:Button ID="LoadButton" runat="server" Text="Load" OnClick="LoadButton_Click" />
        <asp:Button ID="ClearButton" runat="server" Text="Clear" OnClick="ClearButton_Click" />
        <asp:Button ID="SaveButton" runat="server" Text="Save" OnClientClick="$('#QueryHidden').val(editor.getValue());" OnClick="SaveButton_Click" />

        <asp:Button ID="RunButton" runat="server" Text="Run" OnClick="RunButton_Click" />
        <asp:Button ID="LoadCustomerButton" runat="server" Text="Load Customers" OnClick="LoadCustomerButton_Click" />
        <asp:Button ID="LoadSampleData" runat="server" Text="Load Sample Data" OnClick="LoadSampleData_Click" />

        <asp:Button ID="GoToTopButton" runat="server" Text="Go to Top" OnClientClick="$('html, body').animate({ scrollTop: 0 }, 'slow');return(false);" />
    </div>

    <br />
    <br />
    <br />

    <asp:TextBox ID="QueryTextBox" runat="server" TextMode="MultiLine" Width="1000">
    </asp:TextBox>
    <asp:HiddenField ID="QueryHidden" runat="server" />

    <br />

    <p class="vpad16">
        <div style="width: 100%; max-height: 400px; overflow: auto">
            <asp:GridView ID="SQLGridView" EnableTheming="false" CssClass="grid2" HeaderStyle-CssClass="grid2-header" RowStyle-CssClass="grid2-row" AlternatingRowStyle-CssClass="grid2-row-alt" runat="server" ShowHeaderWhenEmpty="true">
            </asp:GridView>
            <asp:Literal ID="MessageLiteral" runat="server" />
        </div>
    </p>

</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="BottomScriptContentPlaceHolder"
    runat="server">

    <script type="text/javascript">
        var mime = 'text/x-plsql';

        if (window.location.href.indexOf('mime=') > -1) {
            mime = window.location.href.substr(window.location.href.indexOf('mime=') + 5);
        }

        editor = CodeMirror.fromTextArea(document.getElementById("QueryTextBox"), {
            mode: mime,
            lineNumbers: true,
            matchBrackets: true,
            autoMatchParens: true,
            tabMode: 'spaces',
            tabSize: 4,
            indentUnit: 4,
            viewportMargin: Infinity,

        });

        editor.setOption("theme", "visual-studio");
        editor.refresh();

        $().ready(function () {
            var $scrollingDiv = $("#buttons");

            $(window).scroll(function () {
                $scrollingDiv
                    .stop()
                    .animate({ "marginTop": ($(window).scrollTop()) }, "slow");
            });
        });
    </script>
</asp:Content>


<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void ClearButton_Click(object sender, EventArgs e)
    {
        QueryTextBox.Text = "";
    }
    protected void LoadButton_Click(object sender, EventArgs e)
    {
        this.LoadSQL();
    }

    private void LoadSQL()
    {
        string sql = System.IO.File.ReadAllText(Server.MapPath("~/db/mixerp.postgresql.bak.sql"));
        QueryTextBox.Text = sql;
    }


    protected void RunButton_Click(object sender, EventArgs e)
    {
        string sql = System.IO.File.ReadAllText(Server.MapPath("~/db/mixerp.postgresql.bak.sql"));
        using(System.Data.DataTable table = MixERP.net.DatabaseLayer.DBFactory.DBOperations.GetDataTable(new Npgsql.NpgsqlCommand(sql)))
        {
            MessageLiteral.Text = string.Format("<div class='success'>{0} row(s) affected.</div>", table.Rows.Count);
            SQLGridView.DataSource = table;
            SQLGridView.DataBind();
        }
    }

    protected void LoadCustomerButton_Click(object sender, EventArgs e)
    {
        string sql = System.IO.File.ReadAllText(Server.MapPath("~/db/customer-sample.sql"));
        using(System.Data.DataTable table = MixERP.net.DatabaseLayer.DBFactory.DBOperations.GetDataTable(new Npgsql.NpgsqlCommand(sql)))
        {
            MessageLiteral.Text = string.Format("<div class='success'>{0} row(s) affected.</div>", table.Rows.Count);
            SQLGridView.DataSource = table;
            SQLGridView.DataBind();
        }
    }

    protected void LoadSampleData_Click(object sender, EventArgs e)
    {
        string sql = System.IO.File.ReadAllText(Server.MapPath("~/db/sample-data.sql"));
        using(System.Data.DataTable table = MixERP.net.DatabaseLayer.DBFactory.DBOperations.GetDataTable(new Npgsql.NpgsqlCommand(sql)))
        {
            MessageLiteral.Text = string.Format("<div class='success'>{0} row(s) affected.</div>", table.Rows.Count);
            SQLGridView.DataSource = table;
            SQLGridView.DataBind();
        }
    }

    protected void ExecuteButton_Click(object sender, EventArgs e)
    {
        try
        {
            using(System.Data.DataTable table = MixERP.net.DatabaseLayer.DBFactory.DBOperations.GetDataTable(new Npgsql.NpgsqlCommand(QueryTextBox.Text)))
            {
                MessageLiteral.Text = string.Format("<div class='success'>{0} row(s) affected.</div>", table.Rows.Count);
                SQLGridView.DataSource = table;
                SQLGridView.DataBind();
            }
        }
        catch(Exception ex)
        {
            MessageLiteral.Text = "<div class='error'>" + ex.Message + "</div>";
        }
    }

    protected void SaveButton_Click(object sender, EventArgs e)
    {
        string sql = QueryHidden.Value;

        if(!string.IsNullOrWhiteSpace(sql))
        {
            string path = Server.MapPath("~/db/mixerp.postgresql.bak.sql");
            System.IO.File.Delete(path);
            System.IO.File.WriteAllText(path, sql, Encoding.UTF8);
        }
    }
</script>
