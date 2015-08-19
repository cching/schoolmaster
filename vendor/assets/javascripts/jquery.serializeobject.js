(function ($, a) {
    $.fn.serializeObject = function () {
        var b = {};
        $.each(this.serializeArray(), function (d, e) {
            var f = e.name,
                c = e.value;
            b[f] = b[f] === a ? c : $.isArray(b[f]) ? b[f].concat(c) : [b[f], c]
        });
        return b
    }
})(jQuery);