function loadEdit() {
    function request(primaryKeyValue) {
        var url = scrudFactory.formAPI + "/" + primaryKeyValue;
        return getAjaxRequest(url);
    };

    var queryString = getQueryStringByName(scrudFactory.queryStringKey || "");

    if (!queryString) {
        createForm();
        return;
    };

    var ajax = request(queryString);

    ajax.success(function (response) {
        editData = response;
        createForm();
    });
};
