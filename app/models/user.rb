class User < ActiveRecord::Base

  SESSION_TIME_MIN = 100.to_i

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, :presence => true, :length => { :maximum => 40 }
  validates :login, :presence => true, :uniqueness => true
  validates :email,
    :presence => true,
    :uniqueness => { :case_sensitive => false },
    :format => { :with => email_regex }
  validates :address, :presence => true
  validates :password, :presence => true,
                       :confirmation => true,
                       :length => { :within => 6..40 }


  has_many :compares, :dependent => :destroy
  has_many :carts
  has_many :comments
  has_many :ratings

  attr_accessor :password_confirmation
  attr_reader :password

  def password=(password)
    @password = password

    return nil if password.blank?
    self.salt = generate_salt
    self.hashed_pass = User.encrypt_password(password, salt)
  end

  def User.authenticate(login, password)
    return nil if not user = find_by_login(login)
    return nil if user.hashed_pass != encrypt_password(password, user.salt)
    set_session_params(user)
    user
  end

  def User.encrypt_password(password, salt)
    Digest::SHA2.hexdigest(password + salt)
  end

  def User.create_guest
    user = User.new
    set_session_params(user)
    user
  end

  def User.authenticate_with_sid(secure_id)
    user = User.find_by_secure_id(secure_id.to_s)
    return nil if !user
    if user.expires_at <= Time.now.utc and user.login.nil?
      current_carts = user.carts.where(:purchased_at => nil) if !user.carts.blank?
      current_carts.first.destroy if current_carts && current_carts.first
      user.destroy
    end
    # if user
    #   user.expires_at = SESSION_TIME_MIN.minutes.from_now.utc
    #   user.save(:validate => false)
    # end
    (user && user.expires_at > Time.now.utc) ? user : nil
  end

  def User.all_registered
    User.where("name IS NOT NULL")
  end

  acts_as_gmappable

  def gmaps4rails_address
    address
  end

  private

    def User.set_session_params(user)
      user.secure_id = generate_secure_id
      user.expires_at = SESSION_TIME_MIN.minutes.from_now.utc
      user.save(:validate => false)
    end

    def User.generate_secure_id
      Digest::SHA2.hexdigest(Time.now.to_s + rand(1000000).to_s)
    end

    def generate_salt
      self.object_id.to_s + rand(255).to_s
    end

end
