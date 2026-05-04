(function () {
    function bindLegacyGrid($) {
        $(".legacy-grid tr").hover(
            function () { $(this).addClass("legacy-hover"); },
            function () { $(this).removeClass("legacy-hover"); }
        );
    }

    function bindStatusConfirm($) {
        $(".js-confirm-status").click(function () {
            return window.confirm("Status aendres med det samme. Fortsaet?");
        });
    }

    if (window.jQuery) {
        window.jQuery(function ($) {
            bindLegacyGrid($);
            bindStatusConfirm($);
        });
    }
})();
