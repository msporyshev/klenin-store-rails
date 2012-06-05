class Admin::GeoController < ApplicationController
  def index
    if (params[:search])
      @json = User.where("name IS NOT NULL").
        where(id: params[:search][:user_ids]).to_gmaps4rails do |user, marker|
        init_user_markers(user, marker)
      end
    else
      @json = User.where("name IS NOT NULL AND login <> ?", STORE_NAME).to_gmaps4rails do |user, marker|
        init_user_markers(user, marker)
      end
    end
  end

  private
end
