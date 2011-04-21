// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(document).ready(function() {

    $('.error, .warning, .notice').each(function(index, item) {
        item = $(item);
        $.jnotify(item.text(), { type: item.attr('class'), sticky: true });
    });
});
