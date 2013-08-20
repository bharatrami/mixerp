<%-- 
Copyright (C) Binod Nepal, Mix Open Foundation (http://mixof.org).

This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. 
If a copy of the MPL was not distributed  with this file, You can obtain one at 
http://mozilla.org/MPL/2.0/.
--%>

<%@ Page Title="" Language="C#" MasterPageFile="~/MenuMaster.Master" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="MixERP.Net.FrontEnd.Dashboard.Index" %>

<%@ Register Assembly="System.Web.DataVisualization, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI.DataVisualization.Charting" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ScriptContentPlaceHolder" runat="server">

    <script src="/Scripts/gridster/jquery.gridster.js"></script>
    <link href="/Scripts/gridster/jquery.gridster.min.css" rel="stylesheet" />
    <script type="text/javascript">
        var gridster;

        $(function () {

            gridster = $(".gridster > ul").gridster({
                widget_margins: [10, 10],
                widget_base_dimensions: [116, 122],
                min_cols: 2
            }).data('gridster');

        });
    </script>
    <style type="text/css">
        ul, ol
        {
            list-style: none;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="StyleSheetContentPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="BodyContentPlaceHolder" runat="server">

    <div style="width: 1092px; margin: auto;">
        <h1 style="margin-left:12px;">Binod, Welcome to MixERP Dashboard (Todo Page)</h1>

        <div class="gridster ready">
            <ul style="position: relative;">

                <li data-row="1" data-col="1" data-sizex="4" data-sizey="2" class="gs_w">
                    <div class="panel double-panel">
                        <div class="panel-title">
                            Sales By Office (Todo: Admin Only/Child Offices Only)
                        </div>
                        <div class="panel-content">
                            <asp:Chart runat="server" ID="ctl00" Height="212px" Width="442px">
                                <Series>
                                    <asp:Series Name="California" ChartType="Column">
                                        <Points>
                                            <asp:DataPoint AxisLabel="Jan" YValues="05" />
                                            <asp:DataPoint AxisLabel="Feb" YValues="40" />
                                            <asp:DataPoint AxisLabel="Mar" YValues="45" />
                                            <asp:DataPoint AxisLabel="Apr" YValues="10" />
                                            <asp:DataPoint AxisLabel="May" YValues="80" />
                                            <asp:DataPoint AxisLabel="Jun" YValues="45" />
                                            <asp:DataPoint AxisLabel="Jul" YValues="38" />
                                            <asp:DataPoint AxisLabel="Aug" YValues="22" />
                                            <asp:DataPoint AxisLabel="Sep" YValues="95" />
                                            <asp:DataPoint AxisLabel="Oct" YValues="90" />
                                            <asp:DataPoint AxisLabel="Nov" YValues="70" />
                                            <asp:DataPoint AxisLabel="Dec" YValues="30" />
                                        </Points>
                                    </asp:Series>
                                    <asp:Series Name="Brooklyn" ChartType="Column">
                                        <Points>
                                            <asp:DataPoint AxisLabel="Jan" YValues="50" />
                                            <asp:DataPoint AxisLabel="Feb" YValues="30" />
                                            <asp:DataPoint AxisLabel="Mar" YValues="12" />
                                            <asp:DataPoint AxisLabel="Apr" YValues="18" />
                                            <asp:DataPoint AxisLabel="May" YValues="70" />
                                            <asp:DataPoint AxisLabel="Jun" YValues="38" />
                                            <asp:DataPoint AxisLabel="Jul" YValues="48" />
                                            <asp:DataPoint AxisLabel="Aug" YValues="69" />
                                            <asp:DataPoint AxisLabel="Sep" YValues="42" />
                                            <asp:DataPoint AxisLabel="Oct" YValues="22" />
                                            <asp:DataPoint AxisLabel="Nov" YValues="38" />
                                            <asp:DataPoint AxisLabel="Dec" YValues="60" />
                                        </Points>
                                    </asp:Series>
                                    <asp:Series Name="Memphis" ChartType="Column">
                                        <Points>
                                            <asp:DataPoint AxisLabel="Jan" YValues="10" />
                                            <asp:DataPoint AxisLabel="Feb" YValues="70" />
                                            <asp:DataPoint AxisLabel="Mar" YValues="45" />
                                            <asp:DataPoint AxisLabel="Apr" YValues="40" />
                                            <asp:DataPoint AxisLabel="May" YValues="90" />
                                            <asp:DataPoint AxisLabel="Jun" YValues="60" />
                                            <asp:DataPoint AxisLabel="Jul" YValues="68" />
                                            <asp:DataPoint AxisLabel="Aug" YValues="48" />
                                            <asp:DataPoint AxisLabel="Sep" YValues="25" />
                                            <asp:DataPoint AxisLabel="Oct" YValues="80" />
                                            <asp:DataPoint AxisLabel="Nov" YValues="75" />
                                            <asp:DataPoint AxisLabel="Dec" YValues="95" />
                                        </Points>
                                    </asp:Series>
                                </Series>
                                <Legends>
                                    <asp:Legend Alignment="Center" Docking="Top" />
                                </Legends>
                                <ChartAreas>
                                    <asp:ChartArea Name="ChartArea1" Area3DStyle-IsClustered="true" Area3DStyle-Enable3D="true" Area3DStyle-LightStyle="Simplistic" BackColor="White" BackSecondaryColor="White" BorderColor="Gray">
                                        <AxisX Interval="1"></AxisX>
                                    </asp:ChartArea>
                                </ChartAreas>
                            </asp:Chart>
                        </div>
                    </div>
                </li>

                <li data-row="1" data-col="2" data-sizex="4" data-sizey="2" class="gs_w">
                    <div class="panel double-panel">
                        <div class="panel-title">
                            Sales By Month (In Thousands) (Todo: Admin Only)
                        </div>
                        <div class="panel-content">
                            <asp:Chart runat="server" ID="ctl01" Height="212px" Width="442px">
                                <Series>
                                    <asp:Series Name="PES-NY-BK (Brooklyn Branch)" ChartType="FastLine" BorderWidth="5" Color="GreenYellow">
                                        <Points>
                                            <asp:DataPoint AxisLabel="Jan" YValues="50" />
                                            <asp:DataPoint AxisLabel="Feb" YValues="30" />
                                            <asp:DataPoint AxisLabel="Mar" YValues="45" />
                                            <asp:DataPoint AxisLabel="Apr" YValues="35" />
                                            <asp:DataPoint AxisLabel="May" YValues="66" />
                                            <asp:DataPoint AxisLabel="Jun" YValues="70" />
                                            <asp:DataPoint AxisLabel="Jul" YValues="74" />
                                            <asp:DataPoint AxisLabel="Aug" YValues="45" />
                                            <asp:DataPoint AxisLabel="Sep" YValues="85" />
                                            <asp:DataPoint AxisLabel="Oct" YValues="90" />
                                            <asp:DataPoint AxisLabel="Nov" YValues="92" />
                                            <asp:DataPoint AxisLabel="Dec" YValues="95" />
                                        </Points>
                                    </asp:Series>
                                </Series>
                                <Legends>
                                    <asp:Legend Docking="Top" />
                                </Legends>
                                <ChartAreas>
                                    <asp:ChartArea Name="ChartArea1" BorderColor="Green" BackColor="Green">
                                        <AxisX Interval="1" />
                                    </asp:ChartArea>
                                </ChartAreas>
                            </asp:Chart>
                        </div>
                    </div>
                </li>



                <li data-row="2" data-col="1" data-sizex="2" data-sizey="2" class="gs_w">
                    <div class="panel">
                        <div class="panel-title">
                            Workflow(144)(Todo : Admin Only)
                        </div>
                        <div class="panel-content">
                            <h5>Workflow Today</h5>
                            <hr class="hr" />
                            <ul>
                                <li style="font-weight: bold;">
                                    <a href="#">Flagged Transactions (12)</a>
                                </li>
                                <li style="font-weight: bold;">
                                    <a href="#">In Verification Stack (132)</a>
                                </li>
                                <li>
                                    <a href="#">Automatically Approved by Workflow (485)</a>

                                </li>
                                <li>
                                    <a href="#">Approved Transactions (494)</a>
                                </li>
                                <li>
                                    <a href="#">Rejected Transactions (12)</a>
                                </li>
                                <li>
                                    <a href="#">Closed Transactions (0)</a>
                                </li>
                                <li>
                                    <a href="#">Withdrawn Transactions (152)</a>
                                </li>
                            </ul>
                        </div>
                    </div>
                </li>

                <li data-row="2" data-col="2" data-sizex="2" data-sizey="2" data-sizey="1" class="gs_w">
                    <div class="panel">
                        <div class="panel-title">
                            Office Information (Todo)
                        </div>
                        <div class="panel-content">
                            Your Office : PES-NY-MEM (Memphis Branch)
                    <br />
                            Logged in to : PES-NY-BK (Brooklyn Branch)
                    <br />
                            Last Login IP : 192.168.0.200
                <br />
                            Last Login On : <%=System.DateTime.Now.ToString() %>
                            <br />
                            Current Login IP : 192.168.0.200
                <br />
                            Current Login On: <%=System.DateTime.Now.ToString() %>
                            <br />
                            Role : ADM (Administrators)
                    <br />
                            Department : ITD (IT Department)
                        </div>
                    </div>
                </li>

                <li data-row="2" data-col="3" data-sizex="2" data-sizey="2" class="gs_w">
                    <div class="panel">
                        <div class="panel-title">
                            Alerts (4) (Todo)
                        </div>
                        <div class="panel-content">
                            <ul>
                                <li>
                                    <a href="#">12 purchase orders not sent</a>

                                </li>
                                <li>
                                    <a href="#">15 days since last EOD operation</a>

                                </li>
                                <li>
                                    <a href="#">5 users logged in from another office</a>

                                </li>
                                <li>
                                    <a href="#">12 transactions awaiting verification</a>
                                </li>
                            </ul>
                        </div>
                    </div>

                </li>
                <li data-row="2" data-col="4" data-sizex="2" data-sizey="2" class="gs_w">
                    <div class="panel">
                        <div class="panel-title">
                            MixERP Links (Todo)
                        </div>
                        <div class="panel-content">
                            <ul>
                                <li>
                                    <a href="#">Documentation</a>

                                </li>
                                <li>
                                    <a href="#">Download Source Code</a>

                                </li>
                                <li>
                                    <a href="#">Submit Bugs</a>

                                </li>
                                <li>
                                    <a href="#">Forum</a>
                                </li>
                                <li>
                                    <a href="#">Discussions</a>
                                </li>
                            </ul>
                        </div>
                    </div>
                </li>

















                <li data-row="3" data-col="1" data-sizex="4" data-sizey="2" class="gs_w">
                    <div class="panel double-panel">
                        <div class="panel-title">
                            Top 5 Selling Products of All Time(Todo: Same)
                        </div>
                        <div class="panel-content">
                            <asp:Chart runat="server" ID="ctl02" Height="212px" Width="442px">
                                <Series>
                                    <asp:Series Name="California" ChartType="Column">
                                        <Points>
                                            <asp:DataPoint AxisLabel="IBM Thinkpad II" YValues="05" />
                                            <asp:DataPoint AxisLabel="MacBook Pro" YValues="40" />
                                            <asp:DataPoint AxisLabel="Microsoft Office" YValues="45" />
                                            <asp:DataPoint AxisLabel="Acer Iconia Tab" YValues="10" />
                                            <asp:DataPoint AxisLabel="Samsung Galaxy Tab" YValues="80" />
                                        </Points>
                                    </asp:Series>
                                    <asp:Series Name="Brooklyn" ChartType="Column">
                                        <Points>
                                            <asp:DataPoint AxisLabel="IBM Thinkpad II" YValues="15" />
                                            <asp:DataPoint AxisLabel="MacBook Pro" YValues="30" />
                                            <asp:DataPoint AxisLabel="Microsoft Office" YValues="55" />
                                            <asp:DataPoint AxisLabel="Acer Iconia Tab" YValues="85" />
                                            <asp:DataPoint AxisLabel="Samsung Galaxy Tab" YValues="20" />
                                        </Points>
                                    </asp:Series>
                                    <asp:Series Name="Memphis" ChartType="Column">
                                        <Points>
                                            <asp:DataPoint AxisLabel="IBM Thinkpad II" YValues="10" />
                                            <asp:DataPoint AxisLabel="MacBook Pro" YValues="80" />
                                            <asp:DataPoint AxisLabel="Microsoft Office" YValues="65" />
                                            <asp:DataPoint AxisLabel="Acer Iconia Tab" YValues="48" />
                                            <asp:DataPoint AxisLabel="Samsung Galaxy Tab" YValues="65" />
                                        </Points>
                                    </asp:Series>
                                </Series>
                                <Legends>
                                    <asp:Legend Alignment="Center" Docking="Top" />
                                </Legends>
                                <ChartAreas>
                                    <asp:ChartArea Name="ChartArea1" Area3DStyle-IsClustered="true" Area3DStyle-Enable3D="true" Area3DStyle-LightStyle="Simplistic" BackColor="White" BackSecondaryColor="White" BorderColor="Gray">
                                    </asp:ChartArea>
                                </ChartAreas>
                            </asp:Chart>
                        </div>
                    </div>
                </li>


                <li data-row="3" data-col="2" data-sizex="4" data-sizey="2" class="gs_w">
                    <div class="panel double-panel">
                        <div class="panel-title">
                            Top 5 Selling Products of All Time(Todo: Admin Only)
                        </div>
                        <div class="panel-content">
                            <asp:Chart runat="server" ID="ctl023" Height="212px" Width="442px">
                                <Series>
                                    <asp:Series Name="California" ChartType="Pie" CustomProperties="PieLabelStyle=Disabled">
                                        <Points>
                                            <asp:DataPoint AxisLabel="IBM Thinkpad II" YValues="05" />
                                            <asp:DataPoint AxisLabel="MacBook Pro" YValues="40" />
                                            <asp:DataPoint AxisLabel="Microsoft Office" YValues="45" />
                                            <asp:DataPoint AxisLabel="Acer Iconia Tab" YValues="10" />
                                            <asp:DataPoint AxisLabel="Samsung Galaxy Tab" YValues="80" />
                                        </Points>
                                    </asp:Series>
                                </Series>
                                <Legends>
                                    <asp:Legend Alignment="Center" Docking="Top" />
                                </Legends>
                                <ChartAreas>
                                    <asp:ChartArea Name="ChartArea1"
                                        Area3DStyle-IsClustered="true"
                                        Area3DStyle-Enable3D="true"
                                        Area3DStyle-LightStyle="Simplistic"
                                        BackColor="White"
                                        BackSecondaryColor="White"
                                        BorderColor="Gray">
                                    </asp:ChartArea>
                                </ChartAreas>
                            </asp:Chart>
                        </div>
                    </div>
                </li>



















            </ul>
        </div>

        <div class="vpad16">
            <asp:Button ID="SavePositionButton"
                runat="server"
                Text="Save Position"
                Style="margin-left: 12px;"
                CssClass="button" />

            <asp:Button ID="ResetPositionButton"
                runat="server"
                Text="Reset Position"
                CssClass="button" />

            <asp:Button ID="GoToWidgetManagerButton"
                runat="server"
                Text="Go to Widget Manager (Todo: Admin Only)"
                CssClass="button" />

        </div>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="BottomScriptContentPlaceHolder" runat="server">
</asp:Content>
