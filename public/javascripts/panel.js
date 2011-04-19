var thisPanel  = null;
$(document).ready(function() {
    thisPanel = $('#panel');
    panel.panelResize(thisPanel);
    var activeBlock = null;
    var activeBlockId = null;
    var previousBlockId = null;
    var isitnew = false;
    var panelWidth = "446px";
    var ajax_url = null;
    var original_top = $('#panel-frame').css('top');
    $('.block').bind('click', function(e)
    {
        activeBlock = $(this);
        ajax_url = activeBlock.attr("data-ajax_url");
        activeBlockId = activeBlock.attr('id');
        
        if(e.ctrlKey && !thisPanel.hasClass('opened')) {
            if(activeBlock.hasClass('active')){activeBlock.removeClass('active');}
            else {
                activeBlock.addClass('active');
            }
        } else {
            $('.block.active').removeClass('active');
            var currentPanelWidth=thisPanel.css('left');
            if(!thisPanel.hasClass('opened') && !thisPanel.hasClass(activeBlockId)){
                // Open the Panel
                thisPanel.animate({ left: panelWidth, opacity: 1}, 200, function(){
                    // callback for the thisPanel openeing, should we choose to add one
                }).removeClass('closed').addClass('opened').addClass(activeBlockId);
                activeBlock.addClass('active');
                previousBlockId = activeBlockId;
                panel.panelAjax(activeBlockId, ajax_url);
            } else if (thisPanel.hasClass('opened') && !thisPanel.hasClass(activeBlockId)){
                // Keep the thisPanel open if they click another block
                // remove previous classes besides opened
                thisPanel.removeAttr('class').addClass('opened').addClass(activeBlockId);
                $("#" + previousBlockId).removeClass('active');
                activeBlock.addClass('active');
                previousBlockId = activeBlockId;
                thisPanel.removeClass('closed');
                panel.panelAjax(activeBlockId, ajax_url);
            } else  if (thisPanel.hasClass('opened') && thisPanel.hasClass(activeBlockId)){
                // Close the Panel
                // Remove previous classes besides opened 
                previousBlockId = activeBlockId;
                panel.closePanel(thisPanel);
            }
        }
        
        $('#select-result').html(
                $('.block.active').length + " items selected."
         );      

        return false;
    });
    $('.close').click(function() {
        panel.closePanel(thisPanel);
        return false;
    });
    
    $(window).resize(function(){
        panel.panelResize(thisPanel);
    });
    
    //this is the floating content
    var floatingPanels = $('#panel-frame');
    var container = $('#container');
    if(container.length > 0){
        var bodyY = parseInt(container.offset().top) - 20;
        $(window).scroll(function () { 
            var scrollY = common.scrollTop();
            var isfixed = floatingPanels.css('position') == 'fixed';
            if(floatingPanels.length > 0){
                if ( scrollY > bodyY && !isfixed ) {
                    floatingPanels.stop().css({
                        position: 'fixed',
                        top: 20
                    });
                } else if ( scrollY < bodyY && isfixed ) {
                    floatingPanels.css({
                        position: 'absolute',
                        top: original_top
                    });
                }
            }
        });
    }

    // It is possible for the pane (e.g. right) of a panel to contain navigation
    // links.  When that occurs, it should be possible to click the navigation 
    // link and only that pane reflect the transition to the new page. The element
    // below helps to facilitate that by binding to the click event for a navigation
    // element with the specified id, sending a request to the server using the link
    // selected and then replacing the content of the pane with the response.
    $('#navigation_element > a').live('click', function (e)
    {
        // if a view is a pane within a panel
        $.ajax({
            cache: 'false',
            type: 'GET',
            url: $(this).attr('href'),
            dataType: 'html',
            success: function(data) {
            $("#panel-content").html(data);
            }
        });
        return false;
    });
//end doc ready
});

var panel = (function(){
    return {
        panelAjax : function(name, ajax_url) {
            var spinner = $('#spinner');
            var panelContent = $('#panel-content');
            spinner.show();
            panelContent.hide();
            $.ajax({
                cache: true,
                url: ajax_url,
                dataType: 'html',
                success: function (data, status, xhr) {
                    spinner.hide();
                    panelContent.html(data).fadeIn();
                },
                error: function (xhr, status, error) {
                    spinner.hide();
                    panelContent.text(jQuery.parseJSON(xhr.responseText).message).fadeIn();
                }
            });
        },
        /* must pass a jQuery object */
        panelResize : function(paneljQ){
            if ($('#content').height() > 550){
                paneljQ.height(common.height() - 155);
            } else if (common.height() < 660) {
                paneljQ.height(common.height() - 155);
            } else {
                $('#content').height(549);
                paneljQ.height(490);
            }
            return paneljQ;
        },        
        closePanel : function(jQPanel){
                $('.block.active').removeClass('active');
                jQPanel.animate({
                    left: 0,
                    opacity: 0
                }, 400, function(){
                    //call back for the thisPanel being done closing
                }).removeAttr('class').addClass('closed');
                return false;
        }
    };
})();
