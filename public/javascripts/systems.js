$(document).ready(function() {

  var upload_options = {
    success: system.successful_post
  }
  
  $('.panelform').live('submit', function(e) {
    e.preventDefault();    	
    $(this).ajaxSubmit(upload_options);
  });
  
  $("#factsTable").treeTable({
  initialState: "collapsed"
});

  
});

var system = (function(){
  return {
    successful_post: function(responseText) {   	
      $("#panel-content").html(responseText);
    }
  };
})();
