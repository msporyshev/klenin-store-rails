// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require chosen-jquery
//= require dataTables/jquery.dataTables
//= require dataTables/jquery.dataTables.bootstrap
//= require_tree .

$(function () {
  $("#table_products th a, #table_products .pagination a").live('click', function() {
    $.get (
      this.href.replace("products?", "products.js?"),
      function(data) {
        $("#table_products").html(data);
      },
      "text html"
    );
    return false;
  });

  $("#rows-select, #columns-select, #values-select").change(function() {
    $("#report-ajax-form").submit()
  });

  // $("div").each(
  //   function(index) {
  //     if ($(this).attr("class") !== "comment-elements")
  //       return true

  //     parent_id = $(this).find("input[name=parent_id]").val()

  //     if (parent_id.length == 0)
  //       return true

  //     margin = $("#" + parent_id).css("marginLeft") + "+ 100"
  //     // this.css("marginLeft", margin)
  //     alert(margin)
  //     // $(this).attr("class", "blabla")
  // });

});
