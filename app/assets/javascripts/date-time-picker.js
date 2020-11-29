$(document).on('turbolinks:load', function() {
    if ($(".schedules").length > 0) {
        options = {
            timeZone: gon.time_zone,
            sideBySide: true,
            widgetPositioning: {
                horizontal: 'left'
            }
        }

        $.fn.datetimepicker.Constructor.Default = $.extend({}, $.fn.datetimepicker.Constructor.Default, options)

        $('#start_date').datetimepicker();
        $('#end_time').datetimepicker({
            format: 'LT'
        });

        $("#end_time").on("keypress", function (e) {
            e.preventDefault();
        });
    }
});
