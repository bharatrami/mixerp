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
<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CustomerInvoice.aspx.cs" Inherits="MixERP.Net.FrontEnd.Sales.Confirmation.CustomerInvoice" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <pes:Report ID="CustomerInvoiceReport" runat="server"
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