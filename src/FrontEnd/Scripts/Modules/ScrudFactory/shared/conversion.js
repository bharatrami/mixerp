function toUnderscoreCase(str) {
    return str.replace(/(?:^|\.?)([A-Z])/g, function (x, y) { return "_" + y.toLowerCase() }).replace(/^_/, "");
};

function toProperCase(str) {
    var result = str.replace(/_([a-z])/g, function (g) { return g[1].toUpperCase(); });
    return result.charAt(0).toUpperCase() + result.slice(1);
};
