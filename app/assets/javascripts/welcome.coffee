# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/'


#document.addEventListener 'turbolinks:load', ->
  #$('#search_start_date').datepicker({
  #  dateFormat: "yy-mm-dd"
  #});
  #$('#search_end_date').datepicker({
  #  dateFormat: "yy-mm-dd"
  #});
  #return 

### Set new image file fields to match search results row data ###
$(document).on 'turbolinks:load', ->
  $('#image_search_results').on 'click', '.new_line_item_picture_button', (e) ->
    ticket_number = $(this).data( "ticket-number" )
    $('#image_file_ticket_number').val ticket_number
    customer_name = $(this).data( "customer-name" )
    $('#image_file_customer_name').val customer_name
    event_code = $(this).data( "event-code" )
    $('#image_file_event_code').val event_code
    return