function getProductId(field) {
    var prod_id = field.parent().attr('id').replace(/[^\d]+/,'');
    return prod_id;
}

function fadeUpdate(fieldName, text) {
  var updateField = $(fieldName);
  updateField.fadeOut('fast');
  updateField.text(text);
  updateField.fadeIn('fast');
}

$(document).ready(function() {


  // Setup initial state
  for (var i = 0; i < repo_status.length; i++) {
      var rs = repo_status[i];
      // If we have a sync_id for this repo, lets start the prog bar
      if (rs[1] !== "") {
          content.statusChecker(rs[0], rs[1], rs[2]);
      }
  }

  $('#select_all').click(function(){$('.products input:checkbox').attr('checked',true)});
  $('#select_none').click(function(){$('.products input:checkbox').attr('checked',false)});

  $('#sync_product_form')
   .bind("ajax:success", function(evt, data, status, xhr){
       var syncs = $.parseJSON(data);
       $.each(syncs, function(){
           content.statusChecker(this.repo_id, this.sync_id, this.product_id);
       })
   })
   .bind("ajax:error", function(evt, xhr, status, error){
     alert("something when wrong");
   });
  
  $('.products').find('ul').slideToggle();
  $('.clickable').live('click', function(){

      // Hide the start/stop times
      var prod_id = $(this).parent().find('input').attr('id').replace(/[^\d]+/,'');


      $(this).parent().parent().find('ul').slideToggle();
      var arrow = $(this).parent().find('a').find('img');
      if(arrow.attr("src").indexOf("collapsed") === -1){
          arrow.attr("src", "/images/icons/expander-collapsed.png");

      } else {
          arrow.attr("src", "/images/icons/expander-expanded.png");
      }
      return false;
  })

  $('.product input:checkbox').click(function() {
    $(this).siblings().find('input:checkbox').attr('checked', this.checked);
  });

  $('li.repo input:checkbox').click(function() {
    var td = $(this).parent().parent().parent();
    var parent_cbx = td.find('input:checkbox').first();
    var siblings = parent_cbx.siblings().find('input:checkbox');
    var total = siblings.length;
    var checked = 0;
    siblings.each( function() { if (this.checked == true) checked++; });
    if (total == checked) {
      parent_cbx.attr('checked', true);
    }
    else if (checked > 0) {
      parent_cbx.attr('checked', false);
    }
    else {
      parent_cbx.attr('checked', false);
    }

  });

});


var content = (function(){
    return {
        statusChecker : function(repo, sync, product_id){
            fadeUpdate("#prod_sync_start_" + product_id, ' ');
            var updateField = $("#repo_bar_" + repo);
            updateField.fadeOut('fast');
            updateField.html('');
            cancelButton = $('<a/>')
                .attr("id", "cancel_"+repo)
                .attr("class", "fr")
                .attr("href", "#")
                .text(i18n.cancel);
            progressBar = $('<div/>')
                .attr('class', 'progress')
                .attr('id', "progress_" + repo)
                .text(" ");
            progressBar.progressbar({
                value: 0
            });
            progressBar.appendTo(updateField);
            cancelButton.appendTo(updateField);
            updateField.fadeIn('fast');
            var pu = $.PeriodicalUpdater('/sync_management/status/', {
              data: {repo_id:repo, sync_id:sync},
              method: 'get',
              type: 'json',
            }, function(data) {
               var pb = $('#progress_' + data.repo_id);
               var prod_id = getProductId(updateField);
               $("#repo_sync_start_" + data.repo_id).text(data.start_time);
               // Only stop when we reach 100% and the finish_time is done
               // sometimes they arent both complete
               if (data.progress.progress == 100 && data.finish_time != null) {
                 pu.stop();
                 updateField.html(data.state);
                 fadeUpdate("#repo_sync_finish_" + data.repo_id, data.finish_time);
                 content.updateProduct(prod_id, true);
               } else if (data.progress.progress < 0) {
                 pu.stop();
                 updateField.html(i18n.error);
               } else {
                 
                 pb.progressbar({ value : data.progress.progress});
               }
            });
            cancelButton.click(function(){
                content.cancelSync(repo, sync, updateField, pu);
            })
            return false;
        },
        updateProduct : function (prod_id) {
            $.ajax({
              type: 'GET',
              url: '/sync_management/product_status/',
              data: { product_id: prod_id },
              dataType: 'json',
              success: function(data) {
                $('#table_' + prod_id).find('div.productstatus').html(data.state);
                fadeUpdate("#prod_sync_finish_" + data.product_id, data.finish_time);
                fadeUpdate("#prod_sync_start_" + data.product_id, data.start_time);
              },
              error: function(data) {
                fadeUpdate("#prod_sync_finish_" + data.product_id, data.finish_time);
                fadeUpdate("#prod_sync_start_" + data.product_id, data.start_time);
                alert("got a update product error");
              }
            });
        },
        cancelSync : function(repoid, syncid, updateField, pu){
            pu.stop();
            $.ajax({
              type: 'DELETE',
              url: '/sync_management/' + syncid,
              data: { repo_id: repoid },
              dataType: 'script',
              success: function(data) {
                var prod_id = getProductId(updateField);
                content.updateProduct(prod_id, true);
                updateField.html('Sync Cancelled.');
              },
              error: function(data) {
                pu.start();
              }
            });
        }
    }
})();
