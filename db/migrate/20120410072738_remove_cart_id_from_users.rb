class RemoveCartIdFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :cart_id
  end

  def down
    add_column :users, :cart_id, :integer
  end
end
