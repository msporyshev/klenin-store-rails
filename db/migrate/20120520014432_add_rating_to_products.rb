class AddRatingToProducts < ActiveRecord::Migration
  def change
    add_column :products, :rating, :decimal, {:precision => 10, :scale => 2}

  end
end
