# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  Paloma.controller 'Admin', new: ->
    $(".btn-create-user").click (e) ->
      $(".new_user").validate
        rules:
          'user[name]':
            required: true
          
          'user[email]':
            required: true
            email: true

          'user[password]':
            required: true

        messages:
          'user[name]':
            required: 'Name is required.'
          
          'user[email]':
            required: 'Email is required.'

          'user[password]':
            required: 'Password is required.'
      return
  return