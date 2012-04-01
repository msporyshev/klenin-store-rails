class User < ActiveRecord::Base

  validates :login, :presence => true, :uniqueness => true
  validates :email, :presence => true, :uniqueness => true
  validates :password, :presence => true,
                       :confirmation => true,
                       :length => { :within => 6..40 }

  belongs_to :session

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
    if user.session
      user.session.destroy
    end
    user.build_session
    user.save(:validate => false)
    user
  end

  def User.encrypt_password(password, salt)
    Digest::SHA2.hexdigest(password + salt)
  end

  def User.authenticate_with_sid(secure_id)
    session = Session.authenticate_with_sid(secure_id)
    session ? session.user : nil
  end



  private

    def generate_salt
      self.object_id.to_s + rand(255).to_s
    end

end
