$(document).ready(function() {
	toggle_provider_fields();
	$('#provider_provider_type').change(toggle_provider_fields);
	$('form#edit_provider_2').submit(function(){
	    $('#provider_submit').val("Uploading...").attr("disabled", "true");
    });
});

var toggle_provider_fields = (function() {
	val = $('#provider_provider_type option:selected').val()
	var fields = "#provider_certificate_attributes_contents," + 
					"#provider_login_credential_attributes_username," + 
						"#provider_login_credential_attributes_password";
	if (val == "Generic Yum Collection" || val == "Local") {
		$(fields).attr("disabled", true);			
	}
	else {
		$(fields).removeAttr("disabled");
	}
});