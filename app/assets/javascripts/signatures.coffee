# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/'


###
resizeCanvas = (canvas) ->
  ratio = Math.max(window.devicePixelRatio or 1, 1)
  canvas.width = canvas.offsetWidth * ratio
  canvas.height = canvas.offsetHeight * ratio
  canvas.getContext('2d').scale ratio, ratio
  return

$(document).on 'turbolinks:load', ->
  canvas = document.querySelector('canvas')
  if canvas
    canvas.height = canvas.offsetHeight
    canvas.width = canvas.offsetWidth
    window.onresize = resizeCanvas(canvas)
    resizeCanvas canvas
    signature_pad = new SignaturePad(canvas)
    $('.signature_pad_clear').click ->
      signature_pad.clear()
      return
    $('.signature_pad_save').click (event) ->
      if signature_pad.isEmpty()
        alert 'You must sign to accept the Terms and Conditions'
        event.preventDefault()
      else
        $('.signature_pad_input').val signature_pad.toDataURL()
      return
  return
###