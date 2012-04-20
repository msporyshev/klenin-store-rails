require 'spec_helper'

describe SessionsController do
  render_views

  before(:each) do
    @valid_attr = {
      :login => "test",
      :name => "Slash",
      :email => "user@example.com",
      :password => "123456",
      :password_confirmation => "123456",
      :address => "blabla str."
    }
    @user = User.create!(@valid_attr) # ващета так не делают(
    # @user = { парамс }
    # User.stub!(:find, @user.id).and_return(@user) # а делают чета в таком духе
  end

  it "should sign in a valid user and set it as current" do
    post :create, :login => @valid_attr[:login], :password => @valid_attr[:password]
    assigns(:current_user).should == @user
  end

  it "should redirect to root url if user is valid" do
    post :create, :login => @valid_attr[:login], :password => @valid_attr[:password]
    response.should redirect_to(root_url)
  end

  it "should not sign in and set user as current if he is not valid" do
    post :create, :login => @valid_attr[:login], :password => "invalid"
    assigns(:current_user).should_not == @user
  end

  it "should redirect to sign in url if user is not valid" do
    post :create, :login => @valid_attr[:login], :password => "invalid"
    response.should redirect_to(sessions_new_url)
  end

end

