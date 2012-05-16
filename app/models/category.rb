class Category < ActiveRecord::Base
  validates :name, presence: true

  belongs_to :category
  has_many :categories, :dependent => :destroy
  has_many :products, :dependent => :destroy

  after_create lambda { |category|
      category.path = category.category.nil? ? "#{category.id}." : category.category.path + "#{category.id}."
      category.save!
      }

  def self.root_categories
    Category.where(:category_id => nil)
  end
end
