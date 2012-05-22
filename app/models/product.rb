class Product < ActiveRecord::Base

  validates :description, presence: true

  belongs_to :category
  has_many :images, :dependent => :destroy
  has_many :product_carts
  has_many :comments, :dependent => :destroy
  has_many :compares, :dependent => :destroy
  has_many :ratings, :dependent => :destroy

  after_create lambda { |product|
    product.path = product.category.nil? ? "#{product.id}" : product.category.path + "#{product.id}"
    product.save!
  }

  before_destroy :ensure_not_referenced_by_any_product_cart

  def compare(user)
    user.compares.where(:product_id => id).first
  end

  def is_in_compares(user)
    !compare(user).nil?
  end

  private

    def ensure_not_referenced_by_any_product_cart
      if product_carts.empty?
        return true
      else
        errors.add(:base, 'Product Carts present')
        return false
      end
    end

end
