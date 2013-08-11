<%-- 
Copyright (C) Binod Nepal, Mix Open Foundation (http://mixof.org).

This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. 
If a copy of the MPL was not distributed  with this file, You can obtain one at 
http://mozilla.org/MPL/2.0/.
--%>
<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CustomerInvoice.aspx.cs" Inherits="MixERP.Net.FrontEnd.Sales.Confirmation.CustomerInvoice" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <mixerp:Report ID="CustomerInvoiceReport" runat="server"
        ReportPath="~/Reports/Sources/Sales.View.Sales.CustomerInvoice.xml" AutoInitialize="true" />

    </form>
</body>
</html>
<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        System.Collections.ObjectModel.Collection<System.Collections.ObjectModel.Collection<KeyValuePair<string, string>>> parameters = new System.Collections.ObjectModel.Collection<System.Collections.ObjectModel.Collection<KeyValuePair<string, string>>>();

        System.Collections.ObjectModel.Collection<KeyValuePair<string, string>> list = new System.Collections.ObjectModel.Collection<KeyValuePair<string, string>>();
        list.Add(new KeyValuePair<string, string>("@transaction_master_id", this.Request["TranId"]));

        parameters.Add(list);
        parameters.Add(list);

        CustomerInvoiceReport.Parameters = parameters;
    }
</script>