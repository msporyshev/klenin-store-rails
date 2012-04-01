class Product < ActiveRecord::Base
  validates :description, presence: true

  belongs_to :category
  has_many :product_carts

  after_save lambda { |product|
      product.path = product.category.nil? ? "#{product.id}" : product.category.path + "#{product.id}"
      product.save!
      }

  before_destroy :ensure_not_referenced_by_any_product_cart

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
