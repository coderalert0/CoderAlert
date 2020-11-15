$(document).on('turbolinks:load', function() {
    if ($(".schedules.show").length > 0) {
        eventCalendar();
    }
});

document.addEventListener('turbolinks:before-cache', function () {
    clearCalendar();
});

function eventCalendar() {
    $('#calendar').parent().removeClass('p-20');

    return $('#calendar').fullCalendar({
        header: {
            left: 'prev,next, details',
            center: 'title'
        },
        events: gon.url,
        nextDayThreshold : "09:01:00",
        aspectRatio: 2,
        loading: function( isLoading, view ) {
            if(isLoading) {
                $('#overlay').show();
            } else {
                $('#overlay').hide();
            }
        }
    });
};
function clearCalendar() {
    $('#calendar').fullCalendar('delete');
    $('#calendar').html('');
};