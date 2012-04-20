require 'spec_helper'

describe UsersController do
  render_views

  before :each do
  end

  describe "anonymous user" do
    it "should be authenticated without signed user params"
  end

  describe "signed in user" do
    before(:each) do
      @valid_attr = {
        :login => "test",
        :name => "Slash",
        :email => "user@example.com",
        :password => "123456",
        :password_confirmation => "123456",
        :address => "blabla str."
      }
      # @user = User.create!(@valid_attr)

      #...
    end

    describe "GET show" do

      # it "should show user profile if he is current" do
      #   get :show, :id => @user
      #   assigns(:user).should == @user
      # end

    end

  end
end
