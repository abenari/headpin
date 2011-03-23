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
            change_set.get(environment_id, function(data, status, xhr){ 
                    $("#changeset").replaceWith(data);
                }, function(){
                    //nothin?
                }
            )}
    );

    $(".changeset_remove_product").live('click', function() {
        var environment_id = $(this).attr('data-environment_id');
        var product_id = $(this).attr('data-product_id');
        remove_product_id(environment_id, product_id);
    });

    $(".changeset_promote").live('click', function() {
        var environment_id = $(this).attr('data-environment_id');
        change_set.promote(environment_id,
                function(data, status, xhr) { notification(xhr); $('body').trigger('changeset.update', [environment_id]); },
                function() {});
    });

    $(".changeset_name").change(function() {
      update_changeset_name($(this).attr('data-environment_id'));
    });

    $(window).unload(function() {
        update_changeset_name();
    });
});


