dataConfirmModal.setDefaults({
    title: 'Confirmation',
    commit: 'Continue',
    cancel: 'Cancel',
})

document.addEventListener('turbolinks:before-cache', function () {
    if (document.body.classList.contains('modal-open')) {
        $('.modal').hide()
            .removeAttr('aria-modal')
            .attr('aria-hidden', 'true');
        $('.modal-backdrop').remove();
        $('body').removeClass('modal-open');
    }
});