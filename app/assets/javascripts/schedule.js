$(document).on('turbolinks:load', function() {
    if ($(".schedules").length > 0) {
        init_user_items();
        add_user_item();
    }
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
        var form_id = $("form").attr('id');
        var action = form_id.split('_')[1];

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

    $("select.js-select-users").append("<option value=" + user_id + ">" + el.parentNode.textContent.trim().slice(0, -1) + "</option>")

    update_user_item_priorities();
}

function next_user_item_priority() {
    var max = 0;

    if($('.ui-sortable-handle input').length == 0)
        return max;



    $('.ui-sortable-handle input').each(function(){
        var val = $(this).val();
        if(val > max) max = val;
    });

    return parseInt(max) + 1;
}

function update_user_item_priorities() {
    $('.ui-sortable-handle input').each(function( index ) {
        $(this).val(index);
    });
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