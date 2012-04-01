class SessionsController < ApplicationController
  def new
  end

  def create
    if user = User.authenticate(params[:login], params[:password])
      cookies[:s_id] = {:value => user.secure_id, :expires => 20.minutes.from_now}
      self.current_user = user
      redirect_to root_url, :notice => "Signed In"
    else
      redirect_to sessions_new_url, :alert => "Invalid user/password combination"
    end
  end

  def destroy
    cookies.delete(:s_id)
    self.current_user = nil
    redirect_to root_url, notice: "Signed out!"
  end
end
