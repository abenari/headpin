
$(document).ready(function() {
    $('.subscriptions').each(function() {
        var bar = $(this);
        bar.progressbar({value: bar.data_progress});
    });
});
