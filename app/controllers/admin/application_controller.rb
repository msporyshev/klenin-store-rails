class Admin::ApplicationController < ApplicationController
  before_filter :redirect_if_user_is_not_admin

  def redirect_if_user_is_not_admin
    redirect_to root_url if current_user.role != "admin"
  end
end
