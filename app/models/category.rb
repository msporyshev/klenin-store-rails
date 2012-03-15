class Category < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true

  belongs_to :category
  has_many :categories
  has_many :products

  after_save lambda { |category|
      category.path = category.category.nil? ? "#{category.id}." : category.category.path + "#{category.id}."
      category.save!
      }, :if => lambda{ |category| category.path.nil? }
end
