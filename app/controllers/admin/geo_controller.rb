class Admin::GeoController < ApplicationController
  def index
    if (params[:search])
      @json = User.where("name IS NOT NULL").
        where(id: params[:search][:user_ids]).to_gmaps4rails do |user, marker|
        init_markers(user, marker)
      end
    else
      @json = User.where("name IS NOT NULL").to_gmaps4rails do |user, marker|
        init_markers(user, marker)
      end
    end
  end

  private

    def init_markers(user, marker)
      marker.infowindow render_to_string(
        :partial => "/admin/users/user_short_info",
        :locals => { :user => user}
      )
      marker.sidebar "<span class=\"foo\">#{user.login}</span>"
    end
end
