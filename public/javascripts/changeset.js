var current_changeset_name = "";
var old_changeset_name = "";

function update_changeset_name(environment_id) {
    current_changeset_name = $('.changeset_name').val();
    if (old_changeset_name != current_changeset_name ) {
        change_set.update_name(environment_id, current_changeset_name,
            function(data, status, xhr){
                old_changeset_name = current_changeset_name
                update_status(xhr);
            },
            function(data, status, xhr){
                update_status(xhr);
            });
    }
}

function notification(xhr) {
  $("#notification").html(xhr.responseText);
}

$(document).ready(function() {

    old_changeset_name = $('.changeset_name').val();

    $('body').bind('changeset.update', function(event, environment_id) {
		$.each(change_set.types, function(index, value) {
			change_set.get(value, environment_id, 
				function(data, status, xhr){ $("#changeset-" + value + " div").replaceWith(data);}, 
	            function() {} //nothin for error right now :)?
				);
			});
		}
    );
	$.each(change_set.types, function(index, type) {
	    $(".changeset_remove_" + type).live('click', function() {
	        var environment_id = $(this).attr('data-environment_id');
	        var id = $(this).attr(generate_id_key(type));
	        remove_id(environment_id, id,type);
	    });	
	});

    $(".changeset_name").change(function() {
      update_changeset_name($(this).attr('data-environment_id'));
    });

    $(window).unload(function() {
        update_changeset_name();
    });
});


