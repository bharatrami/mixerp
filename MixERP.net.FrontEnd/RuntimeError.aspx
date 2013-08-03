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
<%@ Page Title="" Language="C#" MasterPageFile="~/ContentMaster.Master" AutoEventWireup="true" CodeBehind="RuntimeError.aspx.cs" Inherits="MixERP.Net.FrontEnd.RuntimeError" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ScriptContentPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="StyleSheetContentPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="BodyContentPlaceHolder" runat="server">
    <h1>Error Occurred</h1>
    <hr class="hr" />

    <p>We tried our best to complete the task, but it failed miserably.</p>

    <br />
    <p>You could notify the project admin if you think this is a serious error. Nonetheless, the exception has been logged and we might be able to help you.</p>

    <br />

    <asp:Literal ID="ExceptionLiteral" runat="server" />
<br />
    <p>
        <a class="menu" href="javascript:history.go(-1);">Go Back to the Previous Page</a>
    </p>

</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="BottomScriptContentPlaceHolder" runat="server">
</asp:Content>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        string server = Request.ServerVariables["SERVER_SOFTWARE"];

        //This is visual studio
        if (string.IsNullOrWhiteSpace(server))
        {
            this.DisplayError();
        }
        else
        {
            bool displayError = System.Configuration.ConfigurationManager.AppSettings["DisplayError"].Equals("true");
            if (displayError)
            {
                this.DisplayError();
            }
        }

    }

    private void DisplayError()
    {
        Exception ex = (Exception)this.Page.Session["ex"];
        StringBuilder s = new StringBuilder();

        if (ex != null)
        {
            s.Append(string.Format("<hr class='hr' />"));
            s.Append(string.Format("<h2>{0}</h2>", ex.Message));

            ExceptionLiteral.Text = s.ToString();
        }
    }

</script>
