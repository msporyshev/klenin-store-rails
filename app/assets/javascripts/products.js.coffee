# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->

  REPLY_COMMENT_MARGIN = "30px"

  findFirstParentElemByClass = (current, className) ->
    parent = current.parentNode
    while $(parent).attr("class") != className then parent = parent.parentNode
    parent

  initCommentsMargins = () ->
    $(".comment-elements").each(
      (index) ->
        if $(this).attr("class") != "comment-elements"
          return true

        parent_id = $(this).find("input[name=parent_id]").val()

        if parent_id.length == 0
          return true

        $(this).css("marginLeft", $("#" + parent_id).css("marginLeft"))
        $(this).css("marginLeft", "+=" + REPLY_COMMENT_MARGIN)
        # alert(margin)
        true
    )

  product_id = window.location.pathname.match(/\d+/)

  if (product_id != null)
    $.get(
      window.location.protocol + "//" + window.location.host + "/comments/" + product_id + ".js"
      (data) ->
        eval(data)
        false
      "script"
    )

  $("#comment-submit-btn, #comment-submit-btn").live(
    "mouseup"
    ()->
      $("#comment-form").modal("hide")
      # initCommentsMargins()
      false
  )

  $("#reply-btn").live(
    "click"
    () ->
      parent_id = $(findFirstParentElemByClass(this, "comment-elements")).attr("id")

      $.get(
        window.location.protocol + "//" + window.location.host + "/comments/new/" + product_id + ".js"
        {comment_id: parent_id}
        (data) ->
          $("#comment-form").html(data)
          $("#comment-form").modal({
            backdrop: true
          })
        "text html"
      )

      false
  )

  $("#comment-btn").live(
    "click"
    () ->
      $.get(
        window.location.protocol + "//" + window.location.host + "/comments/new/" + product_id + ".js"
        (data) ->
          $("#comment-form").html(data)
          $("#comment-form").modal({
            backdrop: true
          })
        "text html"
      )
      false
  )

  $("#edit-comment-btn").live(
    "click"
    () ->
      comment_id = $(findFirstParentElemByClass(this, "comment-elements")).attr("id")
      $.get(
        window.location.protocol + "//" + window.location.host + "/comments/" + comment_id + "/edit.js"
        (data) ->
          $("#comment-form").html(data)
          $("#comment-form").modal({
            backdrop: true
          })
        "text html"
      )
      false
  )


  false