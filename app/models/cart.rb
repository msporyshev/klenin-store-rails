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

  REAL_ROWS_COLS_N_VALS_NAMES = {
    :user => "users.login",
    :category => "categories.name",
    :purchased_at => "carts.purchased_at",
    :quantity => "SUM(product_carts.quantity)",
    :price => "SUM(product_carts.price)",
    :both => "SUM(product_carts.quantity), SUM(product_carts.price)"
  }

  def self.get_report_info(rows, columns, values)
    rows = REAL_ROWS_COLS_N_VALS_NAMES[rows]
    columns = REAL_ROWS_COLS_N_VALS_NAMES[columns]
    values = REAL_ROWS_COLS_N_VALS_NAMES[values]

    return [] if rows.blank? and columns.blank?

    query =<<SQL
SELECT
  #{select_or_group_query_partial(rows, columns, values)}

FROM carts INNER JOIN users ON users.id = carts.user_id
  INNER JOIN product_carts ON product_carts.cart_id = carts.id
  INNER JOIN products ON product_carts.product_id = products.id
  INNER JOIN categories ON categories.id = products.category_id
WHERE carts.purchased_at IS NOT NULL
GROUP BY #{select_or_group_query_partial(rows, columns)}
SQL
    reports = Cart.connection.execute(query)
  end

  private

    def self.select_or_group_query_partial(*args)
      result = ""
      args.each do |arg|
        result += "#{arg}," if !arg.blank?
      end
      result.chop
    end

end
