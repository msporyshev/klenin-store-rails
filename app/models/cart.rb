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

  def purchase(address)
    self.purchased_at = Time.now
    self.address = address
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

  def self.orders
    where("carts.purchased_at IS NOT NULL")
  end

  acts_as_gmappable

  def gmaps4rails_address
    address
  end


  def self.global_search(search_params)
    search_params ||= {}

    search_params[:date_from] = search_params[:date_from].blank? ? "0001-01-01" : search_params[:date_from]
    search_params[:date_to] = search_params[:date_to].blank? ? "3000-01-01" : search_params[:date_to]

    joins(:user, :product_carts => {:product => :category}).
      where(search_query(search_params)).
      where("carts.purchased_at >= ? and carts.purchased_at <= ?",
        search_params[:date_from], search_params[:date_to])



  end

  private


    FILTER_STR_TEMPLATES = {
      product_key_word: "products.description LIKE \"%?%\" ",
      user_ids: "users.id IN (?) ",
      category_ids: "categories.path LIKE \"?.%\"",
      price_range_from: "product_carts.price >= ?",
      price_range_to: "product_carts.price <= ?"
    }

    def self.category_filter_part(key, category_ids)
      filter = "( 1 = 0"
      category_ids.each do |id|
        cur_filter = FILTER_STR_TEMPLATES[:category_ids].clone

        value = connection.quote_string(id)
        cur_filter.gsub!(/\?/, value)

        filter << " OR " << cur_filter
      end

      filter += ")"
    end

    def self.user_filter_part(key, user_ids)
      filter_str = FILTER_STR_TEMPLATES[:user_ids].clone
      value_str = ""
      user_ids.each { |e| value_str << connection.quote_string(e) << "," }
      value_str.chop!

      filter_str.gsub!(/\?/, value_str)
    end

    def self.single_value_filter_part(key, val)
      filter_str = FILTER_STR_TEMPLATES[key.to_sym].clone
      value_str = connection.quote_string(val)
      filter_str.gsub!(/\?/, value_str)
    end

    FILTER_STR_FUNC = {
      product_key_word: method(:single_value_filter_part),
      user_ids: method(:user_filter_part),
      category_ids: method(:category_filter_part),
      price_range_from: method(:single_value_filter_part),
      price_range_to: method(:single_value_filter_part)
    }

    def self.search_query(params)
      query_str = ""
      params.each_pair do |key, val|
        filter_str_func = FILTER_STR_FUNC[key.to_sym]

        next if filter_str_func.nil? || val.is_a?(String) && val.empty? || val.nil?

        query_str << filter_str_func.call(key, val) << " AND "
      end

      query_str << "1 = 1"
    end

end
