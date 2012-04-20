class CreateCompares < ActiveRecord::Migration
  def change
    create_table :compares do |t|
      t.integer :user_id
      t.integer :product_id
    end
  end
end
