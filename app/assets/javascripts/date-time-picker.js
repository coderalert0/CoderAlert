$.fn.datetimepicker.Constructor.Default = $.extend({}, $.fn.datetimepicker.Constructor.Default, {
    timeZone: gon.time_zone,
    sideBySide: true,
    widgetPositioning: {
        horizontal: 'left'
    }
});

$(document).on('turbolinks:load', function () {
    $('#start_date').datetimepicker();
    $('#end_time').datetimepicker({
        format: 'LT'
    });
    $("#start_date").on("change.datetimepicker", function (e) {
        $('#end_time').datetimepicker('minDate', e.date);
    });
    $("#end_time").on("change.datetimepicker", function (e) {
        $('#start_date').datetimepicker('maxDate', e.date);
    });

    $("#end_time").on("keypress", function (e) {
        e.preventDefault();
    });
});