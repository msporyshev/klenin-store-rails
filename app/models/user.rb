class User < ActiveRecord::Base

  SESSION_TIME_SEC = 1000

  validates :login, :presence => true, :uniqueness => true
  validates :email, :presence => true, :uniqueness => true
  validates :password, :presence => true,
                       :confirmation => true,
                       :length => { :within => 6..40 }

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

    s_id = generate_secure_id
    user.secure_id = s_id
    user.expired_at = Time.now + SESSION_TIME_SEC
    user.save!(:validate => false)

    user
  end

  def User.encrypt_password(password, salt)
    Digest::SHA2.hexdigest(password + salt)
  end

  def User.authenticate_with_sid(secure_id)
    user = User.find_by_secure_id(secure_id.to_s)
    (user && user.expired_at > Time.now) ? user : nil
  end



  private

    def User.generate_secure_id
      Digest::SHA2.hexdigest(Time.now.to_s + rand(1000000).to_s)
    end

    def generate_salt
      self.object_id.to_s + rand(255).to_s
    end

end
