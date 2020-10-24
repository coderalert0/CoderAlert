document.addEventListener('turbolinks:load', function () {
    init_user_items();
    add_user_item();
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
        var user_name = selected_option.html();
        var action = $("form").attr('id').match(/(?<=new_)(.*?)(?=_schedule_form)/g)

        $('#users').append("<div class='ui-sortable-handle form-control col-md-11'>" +
            "<span class='ui-icon ui-icon-arrowthick-2-n-s'></span>" + user_name +
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
    var hue = 'rgb(' + (Math.floor((256-199)*Math.random()) + 200) + ',' + (Math.floor((256-199)*Math.random()) + 200) + ',' + (Math.floor((256-199)*Math.random()) + 200) + ')';
    $('.ui-sortable-handle:last').css("background-color", hue);
}