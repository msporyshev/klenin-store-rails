module ApplicationHelper
  @@tree = ""

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = (column == sort_column) ? "cur #{sort_direction}" : nil
    direction = (column == sort_column && sort_direction == "asc") ? "desc" : "asc"
    link_to title, params.merge(:sort_col => column, :sort_dir => direction, :page => nil), {:class => css_class}
  end

  def global_search_form(url, method, hide_submit = false)
    render "global_search_form", {search_url: url, form_method: method, hide_submit: hide_submit}
  end

  def global_search_form_fields()
    render "global_search_form_fields"
  end

  def products_search_form(url, method, hide_submit = false)
    render "products_search_form", {search_url: url, form_method: method, hide_submit: hide_submit}
  end

  def products_search_form_fields()
    render "products_search_form_fields"
  end

  def comments(cur_comment)
    tree = render "single_comment_partial", comment: cur_comment

    cur_comment.comments.each do |comment|
      tree += comments(comment)
    end

    tree.html_safe
  end
end
