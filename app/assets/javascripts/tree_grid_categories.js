var URL = "categories"
$(function() {

  $.extend($.jgrid.edit, {
      mtype: 'PUT'
    });
  $.extend($.jgrid.add, {
      mtype: 'POST'
    });
  $.extend($.jgrid.del, {
      mtype: 'DELETE'
    });

  function serializePostData(postdata) {
    var tmp = {};
    $.extend(tmp, postdata);
    postdata.category = {};
    for(var key in tmp) {
      if (key == "name" || key == "category_id")
        postdata.category[key] = postdata[key];
    }
  }

  var editOptions = {
      onclickSubmit: function(params, postdata) {
        serializePostData(postdata);
        params.url = URL + '/' + postdata.id + ".json";
      },
      closeAfterEdit: true
    };

  var addOptions = {
    mtype: "POST",
    onclickSubmit: function(params, postdata) {
      serializePostData(postdata);
      params.url = URL + ".json";
    },
    closeAfterAdd: true
  };

  var delOptions = {
      onclickSubmit: function(params, postdata) {
        postdata = postdata.toString();

        params.url = URL + '/' + postdata + ".json";
      }
    };

  var searchOptions = {
    onclickSubmit: function(params, postdata) {
      params.url = URL + '/' + postdata + ".json";
    },
    multipleSearch: true,
    showQuery: true
  }

  $("#tree_grid_categories").jqGrid({
      treeGrid: true,
      url: URL + ".json",
      editurl: URL,
      datatype: 'json',
      mtype: 'GET',
      treeGridModel: "adjacency",
      // loadonce: true,
      ExpandColClick: true,
      width: "250",
      height: "auto",
      ExpandColumn : 'name',
      colModel: [
        {name:'id', index:'id', hidden: true},
        {name:'name', index:'name', label:'Name', editrules: {required: true}, editable: true, autowidth: true},
        {
          name:'category_id',
          index:'category_id',
          hidden: true,
          label:'Parent category',
          edittype: "select",
          editrules: {edithidden: true},
          editoptions: {dataUrl: "categories.js"},
          editable: true,
          autowidth: true
        }
      ],
      pager: '#pager_categories',
      onSelectRow: function(row_id) {
        node_id = $("#tree_grid_categories").getCell(row_id, "id");
        $.get("products.js", {"nodeid": node_id}, function(data) {
          $("#table_products").html(data);
        }, "html");
      },
      caption: 'Categories'
    }).navGrid(
      '#pager_categories',
      {edit: true, add: true, del: true, search: true},
      editOptions,
      addOptions,
      delOptions,
      searchOptions
  );
});