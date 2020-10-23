document.addEventListener('turbolinks:load', function () {
    $('#users').sortable({
        stop: function () {
            $('#users input').each(function(idx) {
                $(this).val(idx);
            });
        }
    });
})
