require 'spec_helper'

describe User do

  before(:each) do
    @valid_attr = {
      :login => "test",
      :name => "Slash",
      :email => "user@example.com",
      :password => "123456",
      :password_confirmation => "123456",
      :address => "blabla str."
    }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@valid_attr)
  end

  it "should require a name" do
    no_name_user = User.new(@valid_attr.merge(:name => ""))
    no_name_user.should_not be_valid #эквивалент no_name_user.valid?.should_not == true
  end

  it "should require an address" do
    no_address_user = User.new(@valid_attr.merge(:address => ""))
    no_address_user.should_not be_valid
  end

  it "should require a login" do
    no_login_user = User.new(@valid_attr.merge(:login => ""))
    no_login_user.should_not be_valid
  end

  describe "password validations" do

    it "should require a password" do
      no_password_user = User.new(@valid_attr.merge(:password => ""))
      no_password_user.should_not be_valid
    end

    it "should require a matching password confirm" do
      invalid_password_confirmation_user = User.new(@valid_attr.merge(:password_confirmation => "invalid"))
      invalid_password_confirmation_user.should_not be_valid
    end

    it "should reject short passwords" do
      short = "a" * 5
      attr = @valid_attr.merge(:password => short, :password_confirmation => short)
      User.new(attr).should_not be_valid
    end

    it "should reject long passwords" do
      long = "a" * 41
      attr = @valid_attr.merge(:password => long, :password_confirmation => long)
      User.new(attr).should_not be_valid
    end

  end

  describe "password encryption" do

    before(:each) do
      @user = User.create!(@valid_attr)
    end

    it "should set the encrypted password" do
      @user.hashed_pass.should_not be_blank
    end

    it "should set salt" do
      @user.salt.should_not be_blank
    end

    describe "authentication" do

      it "should return nil on login/password mismatch" do
        wrong_password_user = User.authenticate(@valid_attr[:login], "wrongpass")
        wrong_password_user.should be_nil
      end

      it "should return nil for an login with no user" do
        nonexistent_user = User.authenticate("blablabla", @valid_attr[:password])
        nonexistent_user.should be_nil
      end

      it "should return the user on login/password match" do
        authenticated_user = User.authenticate(@valid_attr[:login], @valid_attr[:password])
        authenticated_user.should == @user
      end

      it "should set secure id" do
        authenticated_user = User.authenticate(@valid_attr[:login], @valid_attr[:password])
        authenticated_user.secure_id.should_not be_blank
      end

      it "should set session expire time" do
        authenticated_user = User.authenticate(@valid_attr[:login], @valid_attr[:password])
        authenticated_user.expires_at.should_not be_blank
      end

    end

  end

  it "should reject names that are too long" do
    long_name = "a" * 51
    long_name_user = User.new(@valid_attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end

  it "should reject duplicate logins" do
    User.create!(@valid_attr)
    user_with_duplicate_email = User.new(@valid_attr.merge(:email => "newuser@user.user"))
    user_with_duplicate_email.should_not be_valid
  end

  describe "email validations" do
    it "should require an email" do
      no_email_user = User.new(@valid_attr.merge(:email => ""))
      no_email_user.should_not be_valid
    end

    it "should accept valid email addresses" do
      addresses = %w[user@foo.com USER@foo.blabla.org google.cool@foo.ru]
      addresses.each do |address|
        valid_email_user = User.new(@valid_attr.merge(:email => address))
        valid_email_user.should be_valid
      end
    end

    it "should reject invalid email addresses" do
      addresses = %w[user@user,user user_user_user.org example.user@foo.]
      addresses.each do |address|
        invalid_email_user = User.new(@valid_attr.merge(:email => address))
        invalid_email_user.should_not be_valid
      end
    end

    it "should reject duplicate email addresses" do
      User.create!(@valid_attr)
      user_with_duplicate_email = User.new(@valid_attr.merge(:login => "newuser"))
      user_with_duplicate_email.should_not be_valid
    end

    it "should reject email addresses identical up to case" do
      upcased_email = @valid_attr[:email].upcase
      User.create!(@valid_attr.merge(:email => upcased_email))
      user_with_duplicate_email = User.new(@valid_attr)
      user_with_duplicate_email.should_not be_valid
    end
  end
end