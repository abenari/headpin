/*
 * Kalpana Global JavaScript File
 * Author: @jrist
 * Date: 09/01/2010
 */

/**
 * Document Ready function
 */
$(document).ready(function (){
	//Add a handler so that if any input has focus
	//   our keyboard shortcuts don't steal it
	$(":input").focus(function() {
		onInputField = true;
	}).blur(function() {
		onInputField = false;
	});
});

/**
 * Window Ready function
 */
$(window).ready(function(){
    $('.fc').parent().css({"text-align":"center"});
});

/**
 * Anonymous function to set up the Syncing AJAX service.
 */
var svc = (function() {
	currentServiceCall = null;
	return {
		returnType : {
				text: "text",
				xml: "xml",
				json: "json"
		}
	};
})();

function update_status() {
  var statusElement = $(".status");
  var i = setInterval(function() {
      $.ajax({
          url: "#{@_request.fullpath}",
          dataType: 'json',
          success: function (json, status, xhr) {
              statusElement.text(json.status);
              if (xhr.status == 200) clearInterval(i);
          },
          error: function (xhr, status, error) {
              statusElement.text(jQuery.parseJSON(xhr.responseText).message);
              clearInterval(i);
          }
      });
  }, 1000);
}  



// Common functionality throughout Kalpana

// Simple function to dump a message to the browser error log
function log(msg) {
    setTimeout(function() {
        throw new Error(msg);
    }, 0);
}

var common = (function() {
    return {
        height: function() {
            return $(window).height();
        },
        width: function() {
            return $(window).width();
        },
        scrollTop: function() {
            return $(window).scrollTop();
        },
        scrollLeft: function() {
            return $(window).scrollLeft();
        }
    };
})();