class CreatePaypalNotifications < ActiveRecord::Migration
  def change
    create_table :paypal_notifications do |t|
      t.text :params
      t.integer :cart_id
      t.string :status
      t.string :transaction_id
    end
  end
end
