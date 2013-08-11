<%-- 
Copyright (C) Binod Nepal, Mix Open Foundation (http://mixof.org).

This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. 
If a copy of the MPL was not distributed  with this file, You can obtain one at 
http://mozilla.org/MPL/2.0/.
--%>
<%@ Page Title="" Language="C#" MasterPageFile="~/ContentMaster.Master" AutoEventWireup="true" CodeBehind="CashBankAccounts.aspx.cs" Inherits="MixERP.Net.FrontEnd.Finance.Setup.CashBankAccounts" %>
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
        MixERP.Net.FrontEnd.UserControls.Forms.FormControl form = (MixERP.Net.FrontEnd.UserControls.Forms.FormControl)this.LoadControl("~/UserControls/Forms/FormControl.ascx");
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
