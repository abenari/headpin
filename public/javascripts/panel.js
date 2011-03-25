var thisPanel  = null;
$(document).ready(function() {
    thisPanel = $('#panel');
    panel.panelResize(thisPanel);
    var activeBlock = null;
    var previousBlockId = null;
    var panelWidth = "476px";
    $('.block').bind('click', function(e)
    {
        activeBlock = $(this);
        var activeBlockId = activeBlock.attr('id');
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
            } else if (thisPanel.hasClass('opened') && !thisPanel.hasClass(activeBlockId)){
                // Keep the thisPanel open if they click another block
                // remove previous classes besides opened
                thisPanel.removeAttr('class').addClass('opened').addClass(activeBlockId);
                $("#" + previousBlockId).removeClass('active');
                activeBlock.addClass('active');
                previousBlockId = activeBlockId;
                thisPanel.removeClass('closed');
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
        
        $('.data').html(activeBlockId + " Name: " + activeBlock.attr('name'));
        return false;
    });
    $('.close').click(function() {
        panel.closePanel(thisPanel);
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
                        top: '11.4em'
                    });
                }
            }
        });
    }
//end doc ready
});

var panel = (function(){
    return {
        /* must pass a jQuery object */
        panelResize : function(paneljQ){
            if ($('#content').height() > 500){
                paneljQ.height(common.height() - 155);
            } else if (common.height() < 700) {
                paneljQ.height(common.height() - 155);
            } else {
                $('#content').height(500);
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
                    $('.data').html('');
                }).removeAttr('class').addClass('closed');
                return false;
        }
    };
})();
