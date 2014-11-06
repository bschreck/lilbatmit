# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#

fly = (x_speed, y_speed, elem) ->
  originalLeft = elem.css("left")
  originalLeft = parseInt(originalLeft[0..originalLeft.length-3])
  console.log "originalLeft", originalLeft
  left = originalLeft
  originalTop = elem.css("top")
  originalTop = parseInt(originalTop[0..originalTop.length-3])
  console.log "originalTop", originalTop
  top = originalTop

  frame = ->
    left +=  x_speed
    top += y_speed
    elem.css("left", left + 'px')
    elem.css("top", top + 'px')


    if (x_speed > 0 and y_speed > 0)
      if (left > window.innerWidth or top > window.innerHeight)
        left = originalLeft
        top = originalTop
    else if (x_speed > 0 and y_speed < 0)
      if (left > window.innerWidth or top < 0)
        left = originalLeft
        top = originalTop
    else if (x_speed < 0 and y_speed > 0)
      if (left < 0 or top > window.innerHeight)
        left = originalLeft
        top = originalTop
    else
      if (left < 0 or top < 0)
        left = originalLeft
        top = originalTop

  id = setInterval(frame, 10)


console.log "shit"

$(document).ready () ->
  console.log $(".head")

  $(".head").each ->
    $(@).css("left", window.innerWidth/2 + "px")
    #x_dir = if (Math.random() > .5) then Math.random() else -1*Math.random()
    dir = Math.random()
    speed = 10
    x_speed = speed*Math.cos(Math.PI*dir)
    y_speed = -1*(speed*Math.sin(Math.PI*dir))


    #console.log "x_speed", x_speed
    #console.log "y_speed", y_speed
    #console.log "this: ", $(@)
    fly(x_speed, y_speed, $(@))
