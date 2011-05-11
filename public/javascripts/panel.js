var thisPanel  = null;
var subpanel = null;
var subpanelSpacing = 35;
$(document).ready(function() {
    thisPanel = $("#panel");
    subpanel = $('#subpanel');

    var activeBlock = null;
    var activeBlockId = null;
    var previousBlockId = null;
    var panelWidth = 446;
    var ajax_url = null;
    var original_top = $('.left').position(top).top;
    var subpanel_top =  $('.left').position(top).top + subpanelSpacing;

    $('#panel-frame').css({"top" : original_top});
    $('#subpanel-frame').css({"top" : subpanel_top});
    panel.panelResize(thisPanel, original_top, false);
    panel.panelResize(subpanel, subpanel_top, true);

    $('.block').live('click', function(e)
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

            if(!thisPanel.hasClass('opened') && thisPanel.attr("data-id") != activeBlockId){
                // Open the Panel                           /4
                thisPanel.animate({ left: (panelWidth + 3) + "px", opacity: 1}, 200, function(){
                    $(this).css({"z-index":"200"});
                }).removeClass('closed').addClass('opened').attr('data-id', activeBlockId);
                activeBlock.addClass('active');
                previousBlockId = activeBlockId;
                panel.panelAjax(activeBlockId, ajax_url, thisPanel);
            } else if (thisPanel.hasClass('opened') && thisPanel.attr("data-id") != activeBlockId){
                panel.closeSubPanel(subpanel); //close the subpanel if it is open

                // Keep the thisPanel open if they click another block
                // remove previous classes besides opened
                thisPanel.addClass('opened').attr('data-id', activeBlockId);
                $("#" + previousBlockId).removeClass('active');
                activeBlock.addClass('active');
                previousBlockId = activeBlockId;
                thisPanel.removeClass('closed');
                panel.panelAjax(activeBlockId, ajax_url, thisPanel);
            } else  if (thisPanel.hasClass('opened') && thisPanel.attr("data-id") == activeBlockId){
                // Close the Panel
                // Remove previous classes besides opened 
                previousBlockId = activeBlockId;
                panel.closeSubPanel(subpanel);
                panel.closePanel(thisPanel);

            }
        }
        //update the selected count
        panel.updateResult();

        return false;
    });


    $('.close').click(function() {
        if($(this).attr("data-close") == "panel") {
            panel.closePanel(thisPanel);
            panel.closeSubPanel(subpanel);
        }
        else {//closing the subpanel
            panel.closeSubPanel(subpanel);
        }
        return false;
    });
    
    $(window).resize(function(){
        panel.panelResize(thisPanel, original_top, false);
        panel.panelResize(subpanel, subpanel_top, true);
    });

    $('#content').resize(function(){
        panel.panelResize(thisPanel, original_top, false);
        panel.panelResize(subpanel, subpanel_top, true);

    });

    $('.subpanel_element').live('click', function(){
        panel.openSubPanel($(this).attr('data-url'));


    });

  //  var floatingPanels = $('#panel-frame');
    var container = $('#container');
    if(container.length > 0){
        var bodyY = parseInt(container.offset().top) - 20;
        $(window).scroll(function () {
            panel.handleScroll($('#panel-frame'), container, original_top, bodyY, 0);
            panel.handleScroll($('#subpanel-frame'), container, subpanel_top, bodyY, 1);
        });
    }

    // It is possible for the pane (e.g. right) of a panel to contain navigation
    // links.  When that occurs, it should be possible to click the navigation 
    // link and only that pane reflect the transition to the new page. The element
    // below helps to facilitate that by binding to the click event for a navigation
    // element with the specified id, sending a request to the server using the link
    // selected and then replacing the content of the pane with the response.
    $('.navigation_element > a').live('click', function (e)
    {
        // if a view is a pane within a panel
        $.ajax({
            cache: 'false',
            type: 'GET',
            url: $(this).attr('href'),
            dataType: 'html',
            success: function(data) {
            $(".panel-content").html(data);
            }
        });
        return false;
    });

//end doc ready
});

var list = (function(){
   return {
       add : function(html) {
           $('#list').append($(html).hide().fadeIn(function(){$(this).addClass("add", 250, function(){$(this).removeClass("add", 250)})}));
           return false;
       },
       remove : function(id){
           $('#' + id).fadeOut(function(){$(this).empty().remove()});
           return false;
       },
       refresh : function(id, url){
           jQid = $('#' + id);
            $.ajax({
                cache: 'false',
                type: 'GET',
                url: url,
                dataType: 'html',
                success: function(data) {
                    notices.checkNotices();
                    jQid.html(data);
                }
            });
           return false;
       }
   }
})();

var panel = (function(){
    return {
        panelAjax : function(name, ajax_url, panel) {
            var spinner = panel.find('#spinner');
            var panelContent = panel.find(".panel-content");
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
        panelResize : function(paneljQ, top, isSubpanel){
            paneljQ.parent().animate({
                top:top
            }, 250);

            //if there is a lot in the list, make the panel a bit larger
            if ($('#content').height() > 619){
                var extraHeight =  common.height() - 192;
                if (isSubpanel)
                    extraHeight -= subpanelSpacing;
                paneljQ.height(extraHeight);
            } else {
                var height = 490;
                if (isSubpanel)
                    height -= subpanelSpacing;
                paneljQ.height(height);
            }
            return paneljQ;
        },        
        closePanel : function(jPanel){
            $('.block.active').removeClass('active');
            jPanel.animate({
                left: 0,
                opacity: 0
            }, 400, function(){
                $(this).css({"z-index":"0"});
            }).removeClass('opened').addClass('closed').attr("data-id", "");
            return false;
        },
        closeSubPanel : function(jPanel){
            if(jPanel.hasClass("opened")){
                jPanel.animate({
                    left: 0,
                    opacity: 0
                }, 400, function(){
                    $(this).css({"z-index":"0"});
                }).removeClass('opened').addClass('closed');
                panel.updateResult();
            }
            return false;
        },
        updateResult : function(){
            $('#select-result').html(
                $('.block.active').length + " items selected."
             );
        },
        openSubPanel : function(url) {
            var thisPanel = $('#subpanel');
            var panelWidth = 446;
            thisPanel.animate({ left: (panelWidth + 3) + "px", opacity: 1}, 200, function(){
                $(this).css({"z-index":"204"});
            }).removeClass('closed').addClass('opened');
            panel.panelAjax('', url, $('#subpanel-frame'));


        },
        handleScroll : function(jQPanel, container, top, bodyY, spacing) {

            var scrollY = common.scrollTop();
            var isfixed = jQPanel.css('position') == 'fixed';
            //alert(scrollY + "," + isfixed + "," + bodyY);
            if(jQPanel.length > 0){
                if ( scrollY > bodyY && !isfixed ) {
                    jQPanel.stop().css({
                        position: 'fixed',
                        top: 40 + subpanelSpacing*spacing
                    });
                } else if ( scrollY < bodyY && isfixed ) {
                    //alert("1. Top:" + top);
                    jQPanel.css({
                        position: 'absolute',
                        top: top
                    });
                }
            }
        }
    }

})();
