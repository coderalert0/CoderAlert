$.fn.datetimepicker.Constructor.Default = $.extend({}, $.fn.datetimepicker.Constructor.Default, {
    timeZone: gon.time_zone,
    sideBySide: true,
    widgetPositioning: {
        horizontal: 'left'
    }
});

$(document).on('turbolinks:load', function () {
    $('#start').datetimepicker();
    $('#end').datetimepicker({
        useCurrent: false
    });
    $("#start").on("change.datetimepicker", function (e) {
        $('#end').datetimepicker('minDate', e.date);
    });
    $("#end").on("change.datetimepicker", function (e) {
        $('#start').datetimepicker('maxDate', e.date);
    });
});