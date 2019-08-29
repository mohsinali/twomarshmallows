# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  Paloma.controller 'Settings', 
    index: ->
      $('.select-time-zone').change ->
        time_zone = $(this).val()

        $.ajax
          type: 'post'
          url: '/settings/update_user_field'
          data:            
            'field': 'time_zone'
            'value': time_zone
          dataType: 'script'
          success: (response) ->            
            $(".current-time-zone").html(time_zone)
            $('.select-time-zone').addClass('is-valid')
            
            setTimeout (->
              $('.select-time-zone').removeClass('is-valid')
              return
            ), 2000


            return
          error: ->
            return
