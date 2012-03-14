class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.text :description
      t.integer :category_id
      t.decimal :price, :scale => 2
      t.string :path
    end
  end
end
