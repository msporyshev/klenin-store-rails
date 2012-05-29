require Rails.root.to_s + "/app/lib/search.rb"

class ApplicationController < ActionController::Base
  protect_from_forgery

  STORE_NAME = "mystore"

  STORE_ADRESS = "76 Ninth Ave, New York, NY"

  helper_method :current_user
  helper_method :current_cart

  protected


    def init_markers(user, marker)
      marker.infowindow render_to_string(
        :partial => "/admin/users/user_short_info",
        :locals => { :user => user}
      )
      marker.sidebar "<span class=\"foo\">#{user.login}</span>"
    end

    def current_user=(user)
      @current_user = user
    end

    def current_user
      @current_user ||= User.authenticate_with_sid(cookies[:s_id].to_s)
      if !@current_user
        sign_in(User.create_guest)
      end
      @current_user
    end

    def current_cart=(cart)
      @current_cart = cart
    end

    def current_cart
      @current_cart ||= Cart.where(:user_id => current_user.id, :purchased_at => nil).last
      if !@current_cart
        @current_cart = @current_user.carts.build
        @current_user.save(:validate => false)
      end
      @current_cart
    end

    def sign_in(user)
      cookies.permanent[:s_id] = user.secure_id
      self.current_user = user
    end

    def sign_up_if_not_signed_in
      redirect_to edit_user_url(current_user) if current_user.name.nil?
    end

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
