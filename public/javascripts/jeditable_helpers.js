$(document).ready(function() {

      $.editable.addInputType('password', {
          element : function(settings, original) {
              var input=$('<input type="password">');
              if(settings.width!='none') {
                  input.width(settings.width);
              }
              if(settings.height!='none') {
                  input.height(settings.height);
              }
              input.attr('autocomplete','off');
              $(this).append(input);
              return(input);
          }
      });

      $('.edit_password').each(function() {
            $(this).editable('edit', {
                  type        :  'password',
                  width        : 440,
                  method      :  'PUT',
                  name        :  $(this).attr('name'),
                  cancel      :  'Cancel',
                  submit      :  'Save',
                  indicator   :  'Saving...',
                  tooltip     :  'Click to edit...',
                  submitdata  :  {authenticity_token: AUTH_TOKEN},
                  onerror     :  function(settings, original, xhr) {
                    original.reset();
                    $("#notification").replaceWith(xhr.responseText);
                  }
              });
      });

      $('.edit_textfield').each(function() {
            $(this).editable('edit', {
                  type        :  'text',
                  width        : 440,                  
                  method      :  'PUT',
                  name        :  $(this).attr('name'),
                  cancel      :  'Cancel',
                  submit      :  'Save',
                  indicator   :  'Saving...',
                  tooltip     :  'Click to edit...',
                  submitdata  :  {authenticity_token: AUTH_TOKEN},
                  onerror     :  function(settings, original, xhr) {
                    original.reset();
                    $("#notification").replaceWith(xhr.responseText);
                  }
              });
      });

      $('.edit_textarea').each(function() {
            $(this).editable('edit', {
                  type        :  'textarea',
                  method      :  'PUT',
                  name        :  $(this).attr('name'),
                  cancel      :  'Cancel',
                  submit      :  'Save',
                  indicator   :  'Saving...',
                  tooltip     :  'Click to edit...',
                  submitdata  :  {authenticity_token: AUTH_TOKEN},
                  rows        :  8,
                  cols          :  60,
                  onerror     :  function(settings, original, xhr) {
                    original.reset();
                    $("#notification").replaceWith(xhr.responseText);
                  }
              });
      });

      $('.edit_provider_type').each(function() {
            $(this).editable('edit', {
                  type        :  'select',
                  width        : 440,                  
                  method      :  'PUT',
                  name        :  $(this).attr('name'),
                  cancel      :  'Cancel',
                  submit      :  'Save',
                  indicator   :  'Saving...',
                  tooltip     :  'Click to edit...',
                  style       :  "inherit",
                  data        :  "{'Red Hat':'Red Hat', 'Generic Yum Collection':'Generic Yum Collection', 'Local':'Local'}",
                  onerror     :  function(settings, original, xhr) {
                    original.reset();
                    $("#notification").replaceWith(xhr.responseText);
                  }
              });
      });
});
