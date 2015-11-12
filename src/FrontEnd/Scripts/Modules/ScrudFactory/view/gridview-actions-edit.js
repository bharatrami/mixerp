function editFormElement(id, value) {
    var targetEl = $("#" + id);

    if (targetEl.length) {
        if (targetEl.hasClass("date")) {
            value = value.toString().toFormattedDate();
        };

        if (targetEl.attr("data-type") === "time") {
            value = getTime(value);
        };

        targetEl.val(value);

        if (targetEl.attr("data-type") === "image") {
            initializeUploader();
        };

        if (targetEl.is("select")) {
            var type = targetEl.attr("data-type");

            if (type === "bool") {
                value = value ? "yes" : "no";
            };

            targetEl.dropdown("set selected", value.toString());
            targetEl.trigger("blur");
            targetEl.trigger("change");
            return;
        };

        targetEl.trigger("blur");
        targetEl.trigger("change");
        targetEl.trigger("keyup");
    };
};

function displayEdit(items) {
    for (var id in items) {
        if (items.hasOwnProperty(id)) {
            var value = items[id];
            if (value != null) {
                editFormElement(toUnderscoreCase(id), value);
            };
        };
    };
};

function displayCustomFields(items) {
    $.each(items, function (i, v) {
        var id = v.FieldName;
        var value = v.Value;

        editFormElement(id, value);
    });
};