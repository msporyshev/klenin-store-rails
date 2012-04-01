class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user

  private

    def current_user=(user)
      @current_user = user
    end

    def current_user
      @current_user ||= User.authenticate_with_sid(cookies[:s_id].to_s)
    end

  protected
    def tree_grid_json(table_content, column_names)
      page = params[:page]
      row_count = params[:rows]
      page_count = (table_content.count.to_f / row_count.to_f).ceil
      n_level = (params[:n_level] || -1).to_i + 1
      json = {}
      json[:page] = page
      json[:total] = page_count
      json[:count] = table_content.count
      json[:rows] = []
      table_content.each do |elem|
        json[:rows] << {
          :id => elem.id,
          :cell => Array.new(column_names.count) { |i| elem[column_names[i]]}
        }
        json[:rows][-1][:cell].push(n_level, elem.category_id, elem.categories.blank?, false)
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
