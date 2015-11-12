function tryParseLocalizedResource(text) {
    var localized = executeFunctionByName("Resources.Titles." + text, window);

    if (!localized) {
        var underscoreCase = toUnderscoreCase(text);
        localized = executeFunctionByName("Resources.ScrudResource." + underscoreCase, window);
    };

    if (localized) {
        return localized;
    };

    return text;
};

function localizeHeaders(el) {
    el.find("thead tr th").each(function () {
        var cell = $(this);
        var name = toUnderscoreCase(cell.text());
        var text = tryParseLocalizedResource(name);
        cell.text(text);

        var column = new Object();

        column.columnName = name;
        column.localized = text;

        localizedHeaders.push(column);
    });
};