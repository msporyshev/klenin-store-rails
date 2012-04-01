class CreateProductCarts < ActiveRecord::Migration
  def change
    create_table :product_carts do |t|
      t.integer :product_id
      t.integer :quantity, default: 1
      t.integer :cart_id
    end
  end
end
