$(document).ready(function() {
  $('#select_all').click(function(){$('.products input:checkbox').attr('checked',true)});
  $('#select_none').click(function(){$('.products input:checkbox').attr('checked',false)});

  $('#sync_product_form')
   .bind("ajax:success", function(evt, data, status, xhr){
       var syncs = $.parseJSON(data);
       $.each(syncs, function(){
           content.statusChecker(this.repo_id, this.sync_id);
       })
   })
   .bind("ajax:error", function(evt, xhr, status, error){
     alert("something when wrong");
   });
  
  $('.products').find('ul').slideToggle();
  $('.clickable').live('click', function(){
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
      //td.children('.clickable')
    }
    else if (checked > 0) {
      parent_cbx.attr('checked', false);
      //td.children('.clickable')
    }
    else {
      parent_cbx.attr('checked', false);
      //td.children('.clickable')
    }

  });

});

var content = (function(){
    return {
        statusChecker : function(repo, sync){
            var updateField = $("#repo_bar_" + repo);
            updateField.fadeOut('fast');
            updateField.html('');
            cancelButton = $('<a/>')
                .attr("id", "cancel_"+repo)
                .attr("class", "fr")
                .attr("href", "#")
                .text(" Cancel");
            cancelButton.click(function(){
                content.cancelSync(repo, updateField);
            })
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
               if (data.progress.progress == 100) {
                 pu.stop();
                 updateField.html('Sync complete.');
                 var prod_id = updateField.parent().attr('id').replace(/[^\d]+/,'');
                 content.updateProduct(prod_id);
               } else if (data.progress.progress < 0) {
                 pu.stop();
                 updateField.html('Error');
               } else {
                 pb.progressbar({ value : data.progress.progress});
               }
            });
            return false;
        },
        cancelSync : function(repo_id, updateField){
            //TODO: Plug in the cancel sync update
            updateField.html('Sync Cancelled.');
        },
        updateProduct : function(prod_id) {
            $.ajax({
              type: 'GET',
              url: '/sync_management/product_status/',
              data: { product_id: prod_id },
              dataType: 'json',
              success: function(data) {
                $('#table_' + prod_id).find('div.productstatus').html(data.progress);
              },
              error: function(data) {
                alert("got a error");
              }
            });
        }

    }
})();
