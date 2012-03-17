var URL = "categories"
$(function() {
  $("#tree_grid_categories").jqGrid({
      treeGrid: true,
      url: URL + ".json",
      editurl: URL,
      datatype: 'json',
      mtype: 'GET',
      treeGridModel: "adjacency",
      loadonce: true,
      ExpandColClick: true,
      width: "200",
      ExpandColumn : 'name',
      colModel: [
        {name:'id', index:'id', hidden: true},
        {name:'name', index:'name', label:'Name', editable: true, autowidth: true}
      ],
      pager: '#pager_categories',
      onSelectRow: function(row_id) {
        node_id = $("#tree_grid_categories").getCell(row_id, "id");
        $.get("products.js", {"nodeid": node_id}, function(data) {
          eval(data);
        });
      },
      caption: 'Categories'
    });
});