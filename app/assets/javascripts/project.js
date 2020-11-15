$(document).on('turbolinks:load', function() {
    populate_key();
});

function populate_key() {
    $('.js-name').on("keyup", function() {
        var myStr = $('.js-name').val();
        var matches = myStr.match(/\b(\w)/g);
        $('.js-key').val(matches.join('').toUpperCase());
    });
}