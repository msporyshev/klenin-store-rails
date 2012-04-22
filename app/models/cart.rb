class Cart < ActiveRecord::Base
  belongs_to :user
  has_many :product_carts, :dependent => :destroy

  def paypal_url(return_url, notify_url)
    values = {
      :business => "seller_1333419540_biz@list.ru",
      :cmd => "_cart",
      :upload => 1,
      :return => return_url,
      :invoice => id,
      :notify_url => notify_url
    }

    product_carts.each_with_index do |item, index|
      values.merge!({
        "amount_#{index + 1}" => item.total_price,
        "item_name_#{index + 1}" => item.product.description,
        "item_number_#{index + 1}" => item.product.id,
        "quantity_#{index + 1}" => item.quantity
      })
    end
    "https://www.sandbox.paypal.com/cgi-bin/webscr?" + values.to_query
  end

  def purchase
    self.purchased_at = Time.now
    self.save
  end

  def add_product(product_id, price)
    current_item = product_carts.find_by_product_id(product_id)
    if current_item
      current_item.quantity += 1
    else
      current_item = product_carts.build(product_id: product_id, price: price)
    end
    current_item
  end

  def total_price
    product_carts.to_a.sum {|item| item.total_price }
  end

  def total_quantity
    product_carts.to_a.sum {|item| item.quantity}
  end

  def self.get_report_info(params = {})
    orders = Cart.includes(:user, {:product_carts => {:product => :category}}).
      joins(:user, {:product_carts => {:product => :category}}).
      where("carts.purchased_at IS NOT NULL").
      all
    reports = []
    orders.each do |order|
      report = {}
      report[:user] = order.user.login
      report[:total_price] = order.total_price
      report[:products] = []
      order.product_carts.each do |e|
        item = {}
        item[:unit_price] = e.price
        item[:quantity] = e.quantity
        item[:category] = e.product.category.name
        report[:products].push item
      end
      report[:total_quantity] = order.total_quantity
      report[:purchased_at] = order.purchased_at
      reports.push report
    end
    return reports
  end

end
