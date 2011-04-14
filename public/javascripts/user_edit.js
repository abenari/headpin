

$(document).ready(function() {

   ratings =
      [{'minScore': 0,
       'className': 'meterFail',
       'text': i18n.very_weak
      },
      {'minScore': 25,
       'className': 'meterWarn',
       'text': i18n.weak
      },
      {'minScore': 50,
       'className': 'meterGood',
       'text': i18n.good
      },
      {'minScore': 75,
       'className': 'meterExcel',
       'text': i18n.strong
      }];

   $('#password_field').simplePassMeter({
      'container': '#password_meter',
      'offset': 10,
      'showOnFocus':false,
      'requirements': {},
      'defaultText':i18n.meterText,
      'ratings':ratings});

    $('#save_password').bind('click',changePassword);

    $('#helptips_enabled').bind('change', checkboxChanged);

    $(".multiselect").multiselect({"dividerLocation":0.5, "sortable":false});
});
