<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="VoucherVerification.ascx.cs" Inherits="MixERP.Net.Core.Modules.Finance.VoucherVerification" %>
<script>
    var scrudFactory = new Object();
    scrudFactory.title = Resources.Titles.JournalVoucher();

    scrudFactory.hiddenAnnotation = ["UserId", "OfficeId"];
    
    scrudFactory.addNewUrl = "Entry/JournalVoucher.mix";

    scrudFactory.defaultAnnotation = [
        { 
            key : "UserId",
            value: window.userId
        },
        {
            key: "OfficeId",
            value: window.metaView.OfficeId
        },
        {
            key: "Book",
            value: ""
        },
        {
            key: "Status",
            value: "Unverified"
        },
        {
            key: "OfficeName",
            value: window.metaView.OfficeName
        },
        {
            key : "From",
            value: window.applicationDates.Today.toFormattedDate()
        },
        { 
            key : "To",
            value: window.applicationDates.Today.toFormattedDate()
        }
    ];

    scrudFactory.customButtons = [
        {
            id: "VerificationApproveButton",
            text: Resources.Titles.Approve()
        },
        {
            id: "VerificationRejectButton",
            text: Resources.Titles.Reject()
        }
    ];

    scrudFactory.customActions = [
        {

            title: Resources.Labels.GoToChecklistWindow(),
            href: "/Modules/Finance/Confirmation/JournalVoucher.mix?TranId={id}",
            icon : "list icon"
        },
        {
            title: Resources.Titles.Print(),
            onclick: "showWindow('/Modules/Finance/Reports/GLAdviceReport.mix?TranId={id}');",
            icon : "print icon"
        }
    ];


    scrudFactory.viewAPI = "/api/transactions/procedures/get-journal-view";
    scrudFactory.viewTableName = "transactions.get_journal_view";
</script>
<div data-ng-include="'/Modules/ScrudFactory/View.html'"></div>

<script src="/Modules/Finance/Scripts/VoucherVerification.ascx.js"></script>
<iframe id="ChecklistFrame" style="display: none;"></iframe>

<script>
    var tranId;
    var approve;
    var url;
    var data;
    var selectedIndex;

    $(document).on("viewready", function () {
        var reasonTextArea = $("#ReasonTextArea");

        var scrudView = $("#ScrudView");
        var modal = $("#ActionModal");
        var verifyButton = $("#VerifyButton");


        function getSelectedItem() {
            var selectedControl = scrudView.find("input:checked").first();
            selectedIndex = parseInt(selectedControl.parent().parent().parent().index());

            if (selectedControl.length) {
                return parseInt2(selectedControl.parent().parent().parent().find("td:nth-child(3)").html());
            };

            return 0;
        };

        function showModal() {
            var header = modal.find(".ui.massive.header");
            var subheader = modal.find(".ui.dividing.header");

            header.html(Resources.Titles.RejectThisTransaction());
            subheader.html(String.format(Resources.Titles.TranIdParameter(), tranId));
            header.removeClass("green").addClass("red");

            if (approve) {
                header.html(Resources.Titles.ApproveThisTransaction());
                header.removeClass("red").addClass("green");
            };

            modal.modal('setting', 'closable', false).modal('show');
        };

        $("#VerificationApproveButton").click(function () {
            tranId = getSelectedItem();

            if (tranId) {
                approve = true;
                showModal();
            };
        });

        $("#VerificationRejectButton").click(function () {
            tranId = getSelectedItem();

            if (tranId) {
                approve = false;
                showModal();
            };
        });

        function loadCheckList(tranId, callBack) {
            var book = scrudView.find("tr").eq(selectedIndex + 1).find("td:nth-child(5)").html();
            var path;

            switch (book) {
                case "Sales.Receipt":
                    path = "/Modules/Sales/Confirmation/Receipt.mix?TranId=" + tranId;
                    break;
                case "Sales.Delivery":
                    path = "/Modules/Sales/Confirmation/Delivery.mix?TranId=" + tranId;
                    break;
            };


            if (!path) {
                return;
            }

            var frame = $("#ChecklistFrame");

            frame.load(function () {
                if (typeof (callBack) === "function") {
                    callBack(book, tranId);
                };
            });

            frame.attr("src", path);
        };

        function sendEmailNotification(book, tranId) {
            var path;

            switch (book) {
                case "Sales.Receipt":
                    path = "/Modules/Sales/Services/Notification/Receipt.asmx/Send";
                    break;
                case "Sales.Delivery":
                    path = "/Modules/Sales/Services/Notification/Delivery.asmx/Send";
                    break;
            };


            if (!path) {
                return;
            };


            var data = appendParameter("", "tranId", tranId);
            data = getData(data);

            getAjax(path, data);
        };

        function ajaxApprove(tranId, reason) {
            url = "/Modules/Finance/Services/Transactions.asmx/Approve";
            data = appendParameter("", "tranId", tranId);
            data = appendParameter(data, "reason", reason);
            data = getData(data);

            return getAjax(url, data);
        };

        function ajaxReject(tranId, reason) {
            url = "/Modules/Finance/Services/Transactions.asmx/Reject";
            data = appendParameter("", "tranId", tranId);
            data = appendParameter(data, "reason", reason);
            data = getData(data);

            return getAjax(url, data);
        };

        function removeRow(index, callback) {
            scrudView.find("tr").eq(index + 1).addClass("negative").fadeOut(500, function () {
                $(this).remove();

                if (typeof (callback) === "function") {
                    callback();
                };
            });
        };

        function hideModal() {
            modal.modal("hide");
        };

        verifyButton.click(function () {
            var reason = reasonTextArea.val();
            var ajaxAction;

            if (approve) {
                ajaxAction = ajaxApprove(tranId, reason);
            } else {
                ajaxAction = ajaxReject(tranId, reason);
            }

            ajaxAction.success(function (msg) {
                var cascadingTranId = parseFloat(msg.d);
                if (cascadingTranId) {

                    scrudView.find("tr td:nth-child(3)").each(function (i) {
                        var tranId = parseFloat($(this).text() || 0);

                        if (cascadingTranId === tranId) {
                            removeRow(i);
                        };
                    });
                };

                //Need to load the checklist page in order to create a PDF document.
                loadCheckList(tranId, sendEmailNotification);
                removeRow(selectedIndex, hideModal);
            });

            ajaxAction.fail(function (xhr) {
                logAjaxErrorMessage(xhr);
            });

            return false;
        });;;

        $(document).keyup(function (e) {
            if (e.ctrlKey) {
                var rowNumber = e.keyCode - 47;

                if (rowNumber < 10) {
                    scrudView.find("tr").eq(rowNumber).find("input").trigger('click');
                };
            };
        });

        shortcut.add("CTRL+K", function () {
            $("#ApproveButton").trigger("click");
        });

        shortcut.add("CTRL+RETURN", function () {
            if (modal.is(":visible")) {
                verifyButton.trigger("click");
            };
        });

        shortcut.add("CTRL+SHIFT+K", function () {
            $("#VerificationRejectButton").trigger("click");
        });


    });

</script>