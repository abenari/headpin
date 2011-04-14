function button_id(id, type) {
	return "#add_remove_" + type + "_" + id;
}
function modify_changeset(environment_id, id, type) {
  $(button_id(id, type)).html().indexOf('Add') > -1 ?
    add_id(environment_id, id, type) :
    remove_id(environment_id, id, type);
}

function toggle_add_button(id,type) {
    $(button_id(id, type)).html('Add').addClass("add_" + type).removeClass('remove_' + type);
}

function toggle_remove_button(id,type) {
    $(button_id(id, type)).html('Remove').addClass("remove_" + type).removeClass('add_'+type);
}

function update_available_content(event, environment_id, id, type) {
  change_set.get(type, environment_id,
          function(data, status, xhr) {
              var changeset_ids = $.map(JSON.parse(data).items, function(item) { return item.id; });
              var available_item_ids = available_ids(type).filter(function(id) { return changeset_ids.indexOf(id) < 0; });
			
              for(var i in changeset_ids) {
                toggle_remove_button(changeset_ids[i], type);
              }
              for(var i in available_item_ids) {
                  toggle_add_button(available_item_ids[i], type);
              }
          },
          function() {},
          "script"
          );
}


function available_ids(type) {
    return $(".content_add_remove_" + type).map(function() {
        return $(this).attr(generate_id_key(type))
    }).get();
}

function ids_in_changeset(type) {
  return $(".changeset_remove_" + type).map(function() {
    return $(this).attr(generate_id_key(type));
  }).get();
}

function add_id(environment_id, id, type) {
    var ids = ids_in_changeset(type);
	ids.push(id);
    change_set.update(type,
        environment_id, ids,
        function(data, status, xhr) { $('body').trigger('changeset.update', [environment_id, id, type]); },
        function() {});
}

function remove_id(environment_id, id, type) {
    var ids = ids_in_changeset(type);
    ids.splice(ids.indexOf(id), 1);

    change_set.update(type,
        environment_id, ids,
        function(data, status, xhr) { $('body').trigger('changeset.update', [environment_id, id, type]); },
        function() {});
}


function sync_accordions(next_accord, event, info) {
  var other_tab = info.newHeader.attr('id');
  $(next_accord).accordion('activate', "#" + other_tab);
}

function accordion_ajax(info) {
  var href = $('a',info.newHeader).attr('href');
  if (href.charAt(0) != '#') {
    info.newContent.load(href);
    $('a',info.newHeader).attr('href','#');
  }
}

function left_accordion_action(event, info) {
  if (info.newContent.length == 0) return;
  sync_accordions('#right_accordion', event, info);
  accordion_ajax(info);  
  $('#left_accordion').accordion('resize');
}

function right_accordion_action(event, info) {
  if (info.newContent.length == 0) return;
  sync_accordions('#left_accordion', event, info);
  $('#right_accordion').accordion('resize');
  accordion_ajax(info);
}

function resizePanels (panel1, panel2){
	
    if ($('#content').height() > 500){
        panel1.height(common.height() - 155);
        panel2.height(common.height() - 155);
    } else if (common.height() < 700) {
        panel1.height(common.height() - 155);
        panel2.height(common.height() - 155);
    } else {
        panel1.height(490);
        panel2.height(490);
    }
}   

function generate_id_key(type) {
	return 'data-' + type + '_id';	
}


$(document).ready(function() {
    $('body').bind('changeset.update', update_available_content);

	$.each(change_set.types, function(index, value) {
	    $(".content_add_remove_" + value).live('click', function() {
		
	      var environment_id = $(this).attr('data-environment_id');
	      var id = $(this).attr(generate_id_key(value));
	      modify_changeset(environment_id, id, value);
	    });
	});

   $('#right_accordion').accordion({active:false,
								 	fillSpace:true,
							        autoHeight:true,   	
                                    changestart:right_accordion_action
                                   });
   $('#left_accordion').accordion({active:false,
	 	fillSpace:true,
        autoHeight:true,
		changestart:left_accordion_action});	
	resizePanels($('#left_accordion'), $('#right_accordion'));
    $('#left_accordion').accordion('activate', 0);
    $('#right_accordion').accordion('activate', 0);
  	

});


