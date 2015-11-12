function validate() {
    var required = $(".form.factory .image.form-field, .form.factory [required]:not(:disabled):not([readonly]):not(.hidden.column)");
    required.trigger("blur");

    var errorFields = window.scrudForm.find(".error:not(.big.error)");

    $.each(errorFields, function (i, v) {
        var label = $(v).find("label");
        console.log(label.html() + " is required");
    });

    var errorCount = errorFields.length;

    if (!errorCount) {
        if (typeof (window.customFormValidator) === "function") {
            var isValid = window.customFormValidator();

            return isValid;
        };

        return true;
    };

    return false;
};

function initializeValidators() {
    $(".dropdown input.search").blur(function () {
        $(this).parent().find("select").trigger("blur");
    });

    function validateField(el) {
        var val = el.val();
        var errorMessage = el.closest(".field").find(".error-message");

        if (!errorMessage.length) {
            errorMessage = $("<span class='error-message' />");
            el.closest(".field").append(errorMessage);
        };

        if (isNullOrWhiteSpace(val)) {
            isValid = false;
            makeDirty(el);

            el.closest(".field").find(".error-message").html(Resources.Labels.ThisFieldIsRequired());
        } else {
            removeDirty(el);
            el.closest(".field").find(".error-message").html("");
        };
    }

    $(".form.factory [required]:not(:disabled):not([readonly])").blur(function () {
        var el = $(this);
        validateField(el);
    });
};