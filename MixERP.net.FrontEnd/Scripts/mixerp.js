//Do not localize these values unless requred
var areYouSureLocalized = "";
var updateTaxLocalized = "";

function getDocHeight() {
    var D = document;
    return Math.max(
                Math.max(D.body.scrollHeight, D.documentElement.scrollHeight),
                Math.max(D.body.offsetHeight, D.documentElement.offsetHeight),
                Math.max(D.body.clientHeight, D.documentElement.clientHeight)
            );

}

var selectItem = function (tb, ddl) {
    var listControl = $("#" + ddl);
    var textBox = $("#" + tb);
    var selectedValue = textBox.val();
    var exists;

    if (listControl.length) {
        listControl.find('option').each(function () {
            if (this.value == selectedValue) {
                exists = true;
            }
        });
    }

    if (exists) {
        listControl.val(selectedValue).trigger('change');
    }
    else {
        textBox.val('');
    }

    triggerChange(ddl);
}

var triggerChange = function (controlId) {
    var element = document.getElementById(controlId);

    if ('createEvent' in document) {
        var evt = document.createEvent("HTMLEvents");
        evt.initEvent("change", false, true);
        element.dispatchEvent(evt);
    }
    else {
        if ("fireEvent" in element)
            element.fireEvent("onchange");
    }

}

var parseFloat2 = function (arg) {
    return parseFloat(arg || 0);
}

var confirmAction = function () {
    return confirm(areYouSureLocalized);
}
