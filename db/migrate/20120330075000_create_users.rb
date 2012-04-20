class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :login
      t.string :name
      t.string :email
      t.string :adress
      t.date :burthday
      t.string :hashed_pass
      t.string :salt
      t.string :secure_id
      t.datetime :expires_at
      t.string :role
      t.integer :cart_id
    end
  end
end
