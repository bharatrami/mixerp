function showView(target) {
    if (!target) {
        target = $(".active[data-target]").attr("data-target") || "grid";
    };

    var url = updateQueryString("View", target);
    window.history.pushState({ path: url }, '', url);
    window.scrudForm.hide();
    $("div[data-target]").hide();
    $("[data-target]").removeClass("active green");
    $('[data-target="' + target + '"]').show().addClass("active green");
    window.scrudView.fadeIn(500);
    loadPageCount(loadGrid);
};