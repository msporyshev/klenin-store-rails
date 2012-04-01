class Product < ActiveRecord::Base
  validates :description, presence: true

  belongs_to :category

  after_save lambda { |product|
      product.path = product.category.nil? ? "#{product.id}" : product.category.path + "#{product.id}"
      product.save!
      }

end
