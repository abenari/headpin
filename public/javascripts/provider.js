$(document).ready(function() {
	toggle_provider_fields();
	$('#kalpana_model_provider_provider_type').change(toggle_provider_fields);
	$('form#edit_kalpana_model_provider_2').submit(function(){
	    $('#kalpana_model_provider_submit').val("Uploading...").attr("disabled", "true");
    });
});

var toggle_provider_fields = (function() {
	val = $('#kalpana_model_provider_provider_type option:selected').val()
	var fields = "#kalpana_model_provider_certificate_attributes_contents," + 
					"#kalpana_model_provider_login_credential_attributes_username," + 
						"#kalpana_model_provider_login_credential_attributes_password";
	if (val == "Generic Yum Collection" || val == "Local") {
		$(fields).attr("disabled", true);			
	}
	else {
		$(fields).removeAttr("disabled");
	}
});