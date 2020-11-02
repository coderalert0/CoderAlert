document.addEventListener('turbolinks:load', function () {
    $('input[type="file"]').change(function(e){
        var file_names = [];
        for (var i = 0; i < e.target.files.length; ++i) {
            file_names.push(e.target.files[i].name);
        }
        $('.custom-file-label').text(file_names.join(', ').slice(0,60));
    });
});