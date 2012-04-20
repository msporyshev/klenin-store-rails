class RenameAdressInUsers < ActiveRecord::Migration
  def up
    rename_column :users, :adress, :address
  end

  def down
    rename_column :users, :address, :adress
  end
end
