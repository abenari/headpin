var change_set = {

    update_product_ids: function(environment_id, product_ids, on_success, on_error) {
      $.ajax({
        type: "PUT",
        url: "/environments/" + environment_id + "/changesets/product_ids",
        data: { product_ids: product_ids },
        cache: false,
        success: on_success,
        error: on_error
      });
    },

    update_name: function(environment_id, name, on_success, on_error) {
        $.ajax({
          type: "PUT",
          url: "/environments/" + environment_id + "/changesets/name",
          data: { name: name },
          cache: false,
          success: on_success,
          error: on_error
        });
    },

    get: function(environment_id, on_success, on_error, data_type) {
      $.ajax({
        type: "GET",
        dataType: data_type == undefined ? "html" : data_type,
        url: "/environments/" + environment_id + "/changesets/",
        cache: false,
        success: on_success,
        error: on_error
      });
    },

    promote: function(environment_id, on_success, on_error) {
        $.ajax({
          type: "POST",
          dataType: "script",
          url: "/environments/" + environment_id + "/changesets/promote",
          cache: false,
          success: on_success,
          error: on_error
        });
    }
};