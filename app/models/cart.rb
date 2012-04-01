class Cart < ActiveRecord::Base
  has_one :session
  has_many :product_carts, :dependent => :destroy

  def add_product(product_id)
    current_item = product_carts.find_by_product_id(product_id)
    if current_item
      current_item.quantity += 1
    else
      current_item = product_carts.build(product_id: product_id)
    end
    current_item
  end

  def total_price
    product_carts.to_a.sum {|item| item.total_price }
  end

end
