(function ($) {
    $.fn.autoInputWidth = function () {
        this.filter('input:text').each(function () {
            var minWidth = $(this).width(),
                maxWidth = $(this).closest('ol').width(),
                val = '',
                input = $(this),
                testSubject = $('<tester/>').css({
                    position: 'absolute',
                    top: -9999,
                    left: -9999,
                    width: 'auto',
                    fontSize: input.css('fontSize'),
                    fontFamily: input.css('fontFamily'),
                    fontWeight: input.css('fontWeight'),
                    letterSpacing: input.css('letterSpacing'),
                    whiteSpace: 'nowrap'
                }),
                check = function () {
                    if (val === (val = input.val())) {
                        return
                    }
                    var escaped = val.replace(/&/g, '&amp;').replace(/\s/g, '&nbsp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
                    testSubject.html(escaped);
                    var testerWidth = testSubject.width(),
                        newWidth = (testerWidth + 20) >= minWidth ? (testerWidth + 20) : minWidth,
                        currentWidth = input.width(),
                        isValidWidthChange = (newWidth < currentWidth && newWidth >= minWidth) || (newWidth > minWidth && newWidth < maxWidth);
                    if (isValidWidthChange) {
                        input.width(newWidth)
                    }
                };
            testSubject.insertAfter(input);
            $(this).bind('keyup keydown blur update', check)
        });
        return this
    }
})(jQuery);