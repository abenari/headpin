
$(document).ready(function() {

    //Make sure when we load the page we get notifs
    $.ajax({
      type: 'GET',
      url: '/notices/get_new/',
      dataType: 'json',
      success: function(data) {
        notices.addNotices(data);
      }
    });

    //start continual checking for new notifications
    notices.start();
})

var notices = {
    checkTimeout: 5000,
    addNotices: function(data) {
        $("#unread_notices").text(data.unread_count);
        
        $('.jnotify-container').empty()

        //skip if there are no new messages
        var new_notices = data.new_notices

        if ((new_notices == null) || (new_notices.length == 0))
            return true;
        
        $.each(new_notices, function(key, val) {
            var options = {
                sticky: false,
                fadeSpeed: 5000,
                slideSpeed: 200,
                type: val.level,
                noticeId: val.id
            }
            
            if (val.global)
                $.jnotify(val.text, options);
            else
                $.jnotify(val.text, options);
        });

        return true;
    },
    start: function () {
        
        var pu = $.PeriodicalUpdater('/notices/get_new/', {
            method: 'get',
            type: 'json',
            minTimeout: notices.checkTimeout,
            maxTimeout: notices.checkTimeout
        }, notices.addNotices);

    }
}
