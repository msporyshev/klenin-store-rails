require "net/http"
require "uri"
require "json"

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

  before_save do |user|
    return if user.address.blank?

    geocode_data = gmaps_get_geocode(user.address).first
    user.latitude = geocode_data[:lat]
    user.longitude = geocode_data[:lng]
  end

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

  # def User.all_with_orders
  #   User.include("orders")
  # end

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

    def gmaps_get_geocode(address)
      geocode_url = "http://maps.googleapis.com/maps/api/geocode/json?language=en&address="
      output_opt = "&sensor=false"

      url = URI.escape(geocode_url + address + output_opt)

      response = gmaps_geocode_response(url)
      result = response_result(response, url)
      result
    end

    def response_result(response, request)
      if response.is_a?(Net::HTTPSuccess)
        result = JSON.parse(response.body)

        if result["status"] == "OK"
          array_data = []
          result["results"].each do |result|
            array_data << {
                       :lat => result["geometry"]["location"]["lat"],
                       :lng => result["geometry"]["location"]["lng"],
                       :matched_address => result["formatted_address"],
                       :bounds => result["geometry"]["bounds"],
                       :full_data => result
                      }
          end

          return array_data
        else
          raise "The address you enterd seems invalid, status was: #{result["status"]}.
          Request was: #{request}"
        end

      else
        raise "The request sent to google was invalid (not http success): #{request}.
        Response was: #{response}"
      end
    end

    def gmaps_geocode_response(url)
      url = URI.parse(url)
      http = Gmaps4rails.http_agent
      Net::HTTP.get_response(url)
    end

end
