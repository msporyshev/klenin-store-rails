class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :text
      t.integer :comment_id
      t.integer :user_id
      t.integer :product_id
      t.timestamps
    end
  end
end
