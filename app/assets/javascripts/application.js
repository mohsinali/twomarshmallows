// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require jquery.validate
//= require paloma
//= require_tree .

$(document).ready(function () {
  Paloma.start();
  if ($(".spinner-button")[0]) {
    Ladda.bind('.spinner-button');
  }
});

// ###################### Meeting Form Validation ######################
function validate_meeting_form() {
  $(".btn-create-meeting").click(function (e) {
    return $(".new_meeting").validate({
      rules: {
        'meeting[title]': {
          required: true
        },
        'meeting[start_time]': {
          required: true
        },
        'meeting[end_time]': {
          required: true
        }
      },
      messages: {
        'meeting[title]': {
          required: 'Meeting title is required.'
        },
        'meeting[start_time]': {
          required: 'Meeting start time is required.'
        },
        'meeting[end_time]': {
          required: 'Meeting end time is required.'
        }
      }
    });
  });
}

// ###################### Datepicker Initialization ######################
function initializeDatePicker(input_id) {
  $('#' + input_id).bootstrapMaterialDatePicker({
    weekStart: 1,
    format: 'dddd DD MMMM YYYY - HH:mm',
    shortTime: true,
    nowButton: true,
    switchOnClick: true
  });
}
