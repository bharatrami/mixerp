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
<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SignIn.aspx.cs" Inherits="MixERP.Net.FrontEnd.SignIn" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link href="themes/purple/main.css" rel="stylesheet" type="text/css" />
    <script src="Scripts/jquery.min.js"></script>
    <title>Sign In</title>
</head>
<body>
    <form id="form1" runat="server">
    <div class="sign-in-logo">
        <a href="/SignIn.aspx">
            <img src="themes/purple/mixerp-logo.png" />
        </a>    
    </div>
    <div class="sign-in">
        <h1>
            Sign In
        </h1>
        <hr />
        <table width="100%">
            <tr>
                <td style="width: 100px;">
                    User Id
                </td>
                <td>
                    <p>
                        <asp:TextBox ID="UserIdTextBox" runat="server" />
                    </p>
                </td>
            </tr>
            <tr>
                <td>
                    Password
                </td>
                <td>
                    <p>
                        <asp:TextBox ID="PasswordTextBox" runat="server" TextMode="Password" />
                    </p>
                </td>
            </tr>
            <tr>
                <td>
                    Select Your Branch
                </td>
                <td>
                    <asp:DropDownList ID="BranchDropDownList" runat="server" DataSourceID="ObjectDataSource1"
                        DataTextField="office_name" DataValueField="office_id">
                    </asp:DropDownList>
                    <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" SelectMethod="GetOffices"
                        TypeName="MixERP.Net.BusinessLayer.Office.Offices"></asp:ObjectDataSource>
                </td>
            </tr>
            <tr>
                <td>
                </td>
                <td>
                    <p>
                        <asp:CheckBox ID="RememberMe" runat="server" Text="&nbsp;Don't Forget Me" />
                    </p>
                </td>
            </tr>
            <tr>
                <td>
                </td>
                <td>
                    <asp:Literal ID="MessageLiteral" runat="server" />
                </td>
            </tr>
            <tr>
                <td>
                </td>
                <td>
                    <p>
                        <asp:Button ID="SignInButton" runat="server" Text="Sign In" OnClick="SignInButton_Click" />
                    </p>
                </td>
            </tr>
            <tr>
                <td>
                </td>
                <td>
                    <p>
                        <a href="#">
                            Can't access your account?</a>
                    </p>
                </td>
            </tr>
        </table>
    </div>
        <script type="text/javascript">
            $("#UserIdTextBox").val('binod');
            $("#PasswordTextBox").val('binod');
        </script>
    </form>
</body>
</html>
<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        UserIdTextBox.Focus();

        if (!IsPostBack)
        {
            if (User.Identity.IsAuthenticated)
            {
                string user = User.Identity.Name;
                if (!string.IsNullOrWhiteSpace(user))
                {
                    string sessionUser = Pes.Utility.Conversion.TryCastString(this.Page.Session["UserName"]);

                    if (string.IsNullOrWhiteSpace(sessionUser))
                    {
                        MixERP.Net.BusinessLayer.Security.User.SetSession(this.Page, user);
                    }

                    Response.Redirect("~/Account/Index.aspx", true);                    
                                    
                }
            }        
        }
    }

    protected void SignInButton_Click(object sender, EventArgs e)
    {
        int officeId = Pes.Utility.Conversion.TryCastInteger(BranchDropDownList.SelectedItem.Value);
        bool results = MixERP.Net.BusinessLayer.Security.User.SignIn(officeId, UserIdTextBox.Text, PasswordTextBox.Text, RememberMe.Checked, this.Page);

        if (!results)
        {
            MessageLiteral.Text = "<span class='error-message'>Username or password incorrect.</span>";
        }
    }
</script>
