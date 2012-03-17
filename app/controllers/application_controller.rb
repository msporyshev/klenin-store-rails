class ApplicationController < ActionController::Base
  protect_from_forgery

  protected
    def tree_grid_json(table_content, column_names)
      page = params[:page]
      row_count = params[:rows]
      page_count = (table_content.count.to_f / row_count.to_f).ceil
      json = {}
      json[:page] = page
      json[:total] = page_count
      json[:count] = table_content.count
      json[:rows] = []
      table_content.each do |elem|
        json[:rows] << {
          :cell => Array.new(column_names.count) { |i| elem[column_names[i]]}
        }
        json[:rows][-1][:cell].push(elem.path.scan(/\./).count, elem.category_id, elem.categories.blank?, false)
      end
      json

    end

    def grid_json(table_content, column_names)
      page = params[:page]
      row_count = params[:rows]
      page_count = (table_content.count.to_f / row_count.to_f).ceil
      json = {}
      json[:page] = page
      json[:total] = page_count
      json[:count] = table_content.count
      json[:rows] = []
      table_content.each do |elem|
        json[:rows] << {
          :cell => Array.new(column_names.count) { |i| elem[column_names[i]]}
        }
      end
      json
    end

end
