class AddAddressGeocodeToCarts < ActiveRecord::Migration
  def change
    add_column :carts, :longitude, :float
    add_column :carts, :latitude, :float
    add_column :carts, :gmaps, :boolean

    Cart.orders.each do |order|
      order.address = "New York"
      order.save!
    end
  end
end
