$(document).ready(function() {

  $("#subscriptionTable").treeTable({
  	initialState: "collapsed",
    clickableNodeNames: true,
    onShow: function(){$.sparkline_display_visible()}  	
  });

});
