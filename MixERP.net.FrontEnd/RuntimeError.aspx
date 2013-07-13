<%@ Page Title="" Language="C#" MasterPageFile="~/ContentMaster.Master" AutoEventWireup="true" CodeBehind="RuntimeError.aspx.cs" Inherits="MixERP.net.FrontEnd.RuntimeError" %>

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
        <a class="menu" href="javascript:history.go(0);">Go Back to the Previous Page</a>
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
