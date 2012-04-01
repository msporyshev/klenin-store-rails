class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.string :secure_id
      t.datetime :expires_at
      t.integer :cart_id
    end
  end
end
