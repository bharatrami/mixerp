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
<%@ Page Title="" Language="C#" MasterPageFile="~/ContentMaster.Master" AutoEventWireup="true" CodeBehind="CashBankAccounts.aspx.cs" Inherits="MixERP.net.FrontEnd.Finance.Setup.CashBankAccounts" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ScriptContentPlaceHolder" runat="server">
    <style>
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="StyleSheetContentPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="BodyContentPlaceHolder" runat="server">
	<asp:PlaceHolder ID="FormPlaceHolder" runat="server"/>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="BottomScriptContentPlaceHolder" runat="server">
<script type="text/javascript">



    var isCash = $("#is_cash_radiobuttonlist input");


    isCash.click(function () {
        updateProperties();
    });

    var updateProperties = function ()
    {
        var val = $("#is_cash_radiobuttonlist").find("input:checked").val();
        console.log(val);

        if (val == 1) {
            $("#bank_name_textbox").val('N/A').prop('readonly', true);
            $("#bank_branch_textbox").val('N/A').prop('readonly', true);
            $("#bank_contact_number_textbox").val('').attr('readonly', true);
            $("#bank_address_textbox").val('').prop('readonly', true);
            $("#bank_account_code_textbox").val('').prop('readonly', true);
            $("#bank_account_type_textbox").val('').prop('readonly', true);
            $("#relationship_officer_name_textbox").val('').prop('readonly', true);
        }
        else {
            $("#bank_name_textbox").val('').removeAttr('readonly');
            $("#bank_branch_textbox").val('').removeAttr('readonly');
            $("#bank_contact_number_textbox").removeAttr('readonly');
            $("#bank_address_textbox").removeAttr('readonly');
            $("#bank_account_code_textbox").removeAttr('readonly');
            $("#bank_account_type_textbox").removeAttr('readonly');
            $("#relationship_officer_name_textbox").removeAttr('readonly');
        }
    }

    $(document).ready(function () {
        updateProperties();
    });
</script>
</asp:Content>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        MixERP.net.FrontEnd.UserControls.Forms.FormControl form = (MixERP.net.FrontEnd.UserControls.Forms.FormControl)this.LoadControl("~/UserControls/Forms/FormControl.ascx");
        form.DenyAdd = false;
        form.DenyEdit = false;
        form.DenyDelete = false;
        form.Width = 2400;
        form.PageSize = 10;


        form.Text = "Cash & Bank Accounts Setup";

        form.TableSchema = "core";
        form.Table = "cash_bank_accounts";
        form.ViewSchema = "core";
        form.View = "cash_bank_account_view";


        form.KeyColumn = "account_id";

        form.DisplayFields = "office.users.user_id-->user_name, core.accounts.account_id-->account_code + ' (' + account_name + ')'";
        form.SelectedValues = "";


        FormPlaceHolder.Controls.Add(form);
    }
</script>
