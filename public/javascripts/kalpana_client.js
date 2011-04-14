var role = {

    create: function(name, on_success, on_error) {
      $.ajax({
        type: "POST",
        url: "/roles/",
        data: { "role":{"name":name}},
        cache: false,
        success: on_success,
        error: on_error
      });
    },

    remove_permission: function(role_id, perm_id, on_success, on_error) {
      $.ajax({
        type: "PUT",
        url: "/roles/" + role_id,
        data: { "role":{
								"permissions_attributes": {"0":
											{"id": perm_id,
											"_destroy":1} }}},
        cache: false,
        success: on_success,
        error: on_error
      });
		},

    get_verbs_and_scopes: function(resource_type, on_success, on_error) {
      $.ajax({
        type: "GET",
        url: "/roles/resource_type/" + resource_type  + "/verbs_and_scopes",
        data: {},
				dataType: 'json',
        cache: false,
        success: on_success,
        error: on_error
      });
		},

    create_or_update_permission: function(method, url, data, on_success, on_error) {
      $.ajax({
        type: method,
        url: url,
        data: data,
        cache: false,
        success: on_success,
        error: on_error,
				dataType: "html"
      });
		},
    get_new: function(role_id, url, on_success) {
      $.ajax({
        type: "GET",
        url: url,
        data: {"role_id":role_id},
        cache: false,
        success: on_success,
        dataType: "html"
      });
    },
    get_existing: function(role_id, perm_id, url, on_success) {
      $.ajax({
        type: "GET",
        url: url,
        data: {"role_id":role_id, "perm_id":perm_id},
        cache: false,
        success: on_success,
        dataType: "html"
      });
    }

}


var user = {

    create: function(username, password, on_success, on_error) {
      $.ajax({
        type: "POST",
        url: "/users/",
        data: { "user":{"username":username, "password":password}},
        cache: false,
        success: on_success,
        error: on_error
      });   
    },
    
   update_user: function(username, options, on_success, on_error) {
      $.ajax({
        type: "PUT",
        url: "/users/" + username,
        data: options,
        cache: false,
        success: on_success,
        error: on_error
      });
   },
    update_password: function(username, password, on_success, on_error) {
      $.ajax({
        type: "PUT",
        url: "/users/" + username,
        data: { "user":{"password":password}},
        cache: false,
        success: on_success,
        error: on_error
      });   
    },
    clear_helptips: function(username, on_success, on_error) {
      $.ajax({
        type: "POST",
        url: "/users/" + username + "/clear_helptips",
        data: {},
        cache: false,
        success: on_success,
        error: on_error
      });
    }

}

var change_set = {
	types:  ["products","packages", "trees","errata"],
	
    update: function(item_type, environment_id, ids, on_success, on_error) {
      $.ajax({
        type: "PUT",
        url: "/environments/" + environment_id + "/changesets/" + item_type,
        data: { ids: ids },
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

    get: function(item_type, environment_id, on_success, on_error, data_type) {
      $.ajax({
        type: "GET",
        dataType: data_type == undefined ? "html" : data_type,
        url: "/environments/" + environment_id + "/changesets/" + item_type,
        cache: false,
        success: on_success,
        error: on_error
      });
    },
};
