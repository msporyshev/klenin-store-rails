class CreateProductCarts < ActiveRecord::Migration
  def change
    create_table :product_carts do |t|
      t.integer :product_id
      t.decimal :price, :precision => 10, :scale => 2
      t.integer :quantity, default: 1
      t.integer :cart_id
    end
  end
end
