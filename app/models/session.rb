class Session < ActiveRecord::Base

  SESSION_TIME_MIN = 1000.to_i

  has_one :user
  belongs_to :cart

  after_create :set_secure_id, :set_expire_time

  def self.authenticate_with_sid(sid)
    session = Session.find_by_secure_id(sid.to_s)
    (session && session.expires_at > Time.now) ? session : nil
  end

  private

    def generate_secure_id
      Digest::SHA2.hexdigest(Time.now.to_s + rand(1000000).to_s)
    end

    def set_secure_id
      self.secure_id = generate_secure_id
      self.save
    end

    def set_expire_time
      self.expires_at = Time.now + SESSION_TIME_MIN.minutes
      self.save
    end
end
