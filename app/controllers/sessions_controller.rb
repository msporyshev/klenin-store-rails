class SessionsController < ApplicationController
  def new
  end

  def create
    if user = User.authenticate(params[:login], params[:password])
      user.carts.push current_cart
      current_user.destroy
      sign_in(user)
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
