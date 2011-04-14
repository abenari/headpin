
$(document).ready(function() {
   
    $('#password_field').live('keyup.kalpana', verifyPassword);
    $('#confirm_field').live('keyup.kalpana',verifyPassword);
    $('#save_user').live('click',createNewUser);
    $('#clear_helptips').live('click',clear_helptips);
    $('#save_roles').live('click',save_roles);
});


function save_roles() {
    var form = $(this).closest("form");
    var dataToSend = form.serialize();
    var username = $(this).attr('data_username');
    user.update_user(username, dataToSend, function() {},function() {});
}

function clear_helptips() {
	var obj = $(this);
	user.clear_helptips(obj.attr("username"),
	    function(data) {
		obj.button('destroy');
		//obj.button('option', 'label', data);
		obj.text(data);
	    },
	    function(data) {
		obj.button('option',  'label', data);
	    })

}


function checkboxChanged() {
	var checkbox = $(this);
	var name = $(this).attr("name");
	var obj = {};
	obj[name] = checkbox.attr("checked");
	user.update_user($(this).attr("data_username"), obj, function(){},function(){});
	
}



//match_button must be defined which is the id of the button to disable
//if a password match fails
function verifyPassword() {
    var match_button = $('.verify_password');
    var a = $('#password_field').val();
    var b = $('#confirm_field').val();
    
    if(a!= b){
        $("#password_conflict").text(i18n.password_match);
        $(match_button).addClass("disabled");
        $('#save_password').unbind('click');
    }
    else {
        $("#password_conflict").text("");
        $(match_button).removeClass("disabled");
        $('#save_password').unbind('click');
        $('#save_password').bind('click',changePassword);

    }
}

//Create user functions
function createNewUser(){
user.create($('#username_field').val(), $('#password_field').val(), 
      successCreate, errorCreate);
}

function successCreate() {
 //alert("Created!");
}

function errorCreate(request) {
 //alert(request.responseText);
}



//Change password functions
function changePassword() {
    user.update_password($(this).attr("data_username")  ,$('#password_field').val(),
        changePasswordSuccess, changePasswordFail);
}

function changePasswordFail(request) {
  //alert(request.responseText);
}

function changePasswordSuccess() {
  //alert("Success");
}



