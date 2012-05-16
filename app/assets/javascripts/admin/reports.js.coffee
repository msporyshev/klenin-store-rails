# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  $("#report").dataTable({
    sPaginationType: "bootstrap",
    "sScrollX": "100%",
    "bScrollCollapse": true
  })

  # $("#download-report-btn").click( ->
  #   var form = $("#global-search-form")
  #   for elem in form.elements
  #     # body...
  # )
