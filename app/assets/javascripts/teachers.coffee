# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  Paloma.controller 'Teachers', 
    index: ->
      Ladda.bind '.spinner-button button, .spinner-button a', callback: (instance) ->
        progress = 0
        interval = setInterval((->
          progress = Math.min(progress + Math.random() * 0.1, 1)
          instance.setProgress progress
          if progress == 1
            instance.stop()
            clearInterval interval
          return
        ), 200)
        return