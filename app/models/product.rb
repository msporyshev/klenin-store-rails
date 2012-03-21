class Product < ActiveRecord::Base
  validates :name, presence: true

  belongs_to :category

  after_save lambda { |product|
      product.path = product.category.nil? ? "#{product.id}" : product.category.path + "#{product.id}"
      product.save!
      }, :if => lambda{ |product| product.path.nil? }

end
