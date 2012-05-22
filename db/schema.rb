# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120522085642) do

  create_table "carts", :force => true do |t|
    t.integer  "user_id"
    t.datetime "purchased_at"
  end

  create_table "categories", :force => true do |t|
    t.string  "name"
    t.integer "category_id"
    t.string  "path"
  end

  create_table "comments", :force => true do |t|
    t.text     "text"
    t.integer  "comment_id"
    t.integer  "user_id"
    t.integer  "product_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "compares", :force => true do |t|
    t.integer "user_id"
    t.integer "product_id"
  end

  create_table "images", :force => true do |t|
    t.integer "product_id"
    t.string  "name"
    t.string  "image_path"
  end

  create_table "paypal_notifications", :force => true do |t|
    t.text    "params"
    t.integer "cart_id"
    t.string  "status"
    t.string  "transaction_id"
  end

  create_table "product_carts", :force => true do |t|
    t.integer "product_id"
    t.decimal "price",      :precision => 10, :scale => 2
    t.integer "quantity",                                  :default => 1
    t.integer "cart_id"
  end

  create_table "products", :force => true do |t|
    t.text    "description"
    t.integer "category_id"
    t.decimal "price",       :precision => 10, :scale => 2
    t.string  "path"
    t.string  "image_url"
    t.decimal "rating",      :precision => 10, :scale => 2
  end

  create_table "ratings", :force => true do |t|
    t.integer  "product_id"
    t.integer  "user_id"
    t.integer  "rating"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "name"
    t.string   "email"
    t.string   "address"
    t.date     "burthday"
    t.string   "hashed_pass"
    t.string   "salt"
    t.string   "secure_id"
    t.datetime "expires_at"
    t.string   "role"
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "gmaps"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
