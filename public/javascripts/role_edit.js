/*
 * A small javascript file needed to load things whenever a role is opened for editing
 *
 */

$(document).ready(function() {
    reset_buttons(); //This is in role.js

    $('.edit_rolename').each(function() {
        $(this).editable($(this).attr('url'), {
            type        :  'text',
            method      :  'PUT',
            name        :  $(this).attr('name'),
            cancel      :  i18n.cancel,
            submit      :  i18n.save,
            indicator   :  i18n.saving,
            tooltip     :  i18n.clickToEdit,
            placeholder :  i18n.clickToEdit,
            submitdata  :  {authenticity_token: AUTH_TOKEN},
            rows        :  8,
            cols        :  60,
            onerror     :  function(settings, original, xhr) {
                            original.reset();
                            $("#notification").replaceWith(xhr.responseText);
                            }
        });
  });

});
