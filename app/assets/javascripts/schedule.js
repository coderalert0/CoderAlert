document.addEventListener('turbolinks:load', function () {
    init_user_items();
    add_user_item();
    init_days_of_the_week();
    toggle_days_of_the_week();
});

function init_user_items() {
    $('#users').sortable({
        stop: function () {
            $('#users input').each(function(idx) {
                $(this).val(idx);
            });
        }
    });
}

function add_user_item() {
    $("select.js-select-users").on("change", function() {
        var selected_option = $(this).children(":selected");
        var user_id = selected_option.val();
        var full_name = selected_option.html();
        var action = $("form").attr('id').match(/(?<=new_)(.*?)(?=_schedule_form)/g)

        $('#users').append("<div class='ui-sortable-handle form-control col-md-11'>" +
            "<span class='ui-icon ui-icon-arrowthick-2-n-s'></span>" + full_name +
            "<span onclick=remove_user_item(this) class='float-right'>x</span>" +
            "<input type=hidden name=" + action + "_schedule_form[users][" + user_id + "] " +
            "id=" + action + "_schedule_form_users_" + user_id + " value=" + next_user_item_priority() + ">" +
            "</div>");

        change_user_item_color();
        selected_option.remove();
    });
}

function remove_user_item(el) {
    var element = el;
    var user_id = el.parentNode.querySelector('input').name.match(/[^[\]]+(?=])/g)[1]

    element.parentNode.remove();

    $("select.js-select-users").append("<option value=" + user_id + ">" + el.parentNode.textContent.slice(0, -1) + "</option>")
}

function next_user_item_priority() {
    var max = 0;

    $('.ui-sortable-handle input').each(function(){
        var val = $(this).val();
        if(val > max) max = val;
    });
    return parseInt(max) + 1;
}

function change_user_item_color() {
    var full_name = $('.ui-sortable-handle:last').text().toLowerCase();
    var indice_ratios = []

    for (var i = 0; i < full_name.length; i++) {
        indice_ratios.push((full_name.charAt(i).charCodeAt(0) - 96)/26);
    }

    var hue = 'rgb(' + (Math.floor(57*indice_ratios[0]) + 200) + ',' + (Math.floor(57*indice_ratios[1]) + 200) + ',' + (Math.floor(57*indice_ratios[2]) + 200) + ')';
    $('.ui-sortable-handle:last').css("background-color", hue);
}

function init_days_of_the_week(){
    if($('.js-interval-unit').val() == 'week') {
        $('.js-days-of-the-week').show();
    } else {
        $('.js-days-of-the-week').hide();
    }
}

function toggle_days_of_the_week(){
    $('.js-interval-unit').on('change', function() {
        if($('.js-interval-unit').val() == 'week') {
            $('.js-days-of-the-week').show();
        } else {
            $('.js-days-of-the-week').hide();
            $('input:checkbox:checked').prop('checked', false);
        }
    });
}