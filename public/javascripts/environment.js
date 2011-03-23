function modify_changeset(environment_id, product_id) {
  $("#add_remove_" + product_id).html().indexOf('Add') > -1 ?
    add_product_id(environment_id, product_id) :
    remove_product_id(environment_id, product_id);
}

function toggle_add_button(product_id) {
    $("#add_remove_" + product_id).html('Add').addClass("add_product").removeClass('remove_product');
}

function toggle_remove_button(product_id) {
    $("#add_remove_" + product_id).html('Remove').addClass("remove_product").removeClass('add_product');
}

function update_available_content(event, environment_id, product_id) {
  change_set.get(environment_id,
          function(data, status, xhr) {
              var changeset_product_ids = $.map(JSON.parse(data).changeset.products, function(product) { return product.cp_id; });
              var available_repository_ids = repository_ids().filter(function(id) { return changeset_product_ids.indexOf(id) < 0; });

              for(var i in changeset_product_ids) {
                toggle_remove_button(changeset_product_ids[i]);
              }
              for(var i in available_repository_ids) {
                  toggle_add_button(available_repository_ids[i]);
              }
          },
          function() {},
          "script"
          );
}

function repository_ids() {
    return $(".content_add_remove_product").map(function() {
        return $(this).attr('data-product_id')
    }).get();
}

function product_ids() {
  return $(".changeset_remove_product").map(function() {
    return $(this).attr('data-product_id')
  }).get();
}

function add_product_id(environment_id, product_id) {
    var productids = product_ids();
    productids.push(product_id);
    change_set.update_product_ids(
        environment_id, productids,
        function(data, status, xhr) { $('body').trigger('changeset.update', [environment_id, product_id]); },
        function() {});
}

function remove_product_id(environment_id, product_id) {
    var productids = product_ids();
    productids.splice(productids.indexOf(product_id), 1);

    change_set.update_product_ids(
        environment_id, productids,
        function(data, status, xhr) { $('body').trigger('changeset.update', [environment_id, product_id]); },
        function() {});
}

$(document).ready(function() {
    $('body').bind('changeset.update', update_available_content);

    $(".content_add_remove_product").live('click', function() {
      var environment_id = $(this).attr('data-environment_id');
      var product_id = $(this).attr('data-product_id');
      modify_changeset(environment_id, product_id);
    });
});


