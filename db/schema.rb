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

ActiveRecord::Schema.define(:version => 20120401062316) do

  create_table "carts", :force => true do |t|
  end

  create_table "categories", :force => true do |t|
    t.string  "name"
    t.integer "category_id"
    t.string  "path"
  end

  create_table "product_carts", :force => true do |t|
    t.integer "product_id"
    t.integer "quantity",   :default => 1
    t.integer "cart_id"
  end

  create_table "products", :force => true do |t|
    t.text    "description"
    t.integer "category_id"
    t.decimal "price",       :precision => 10, :scale => 2
    t.string  "path"
    t.string  "image_url"
  end

  create_table "sessions", :force => true do |t|
    t.string   "secure_id"
    t.datetime "expires_at"
    t.integer  "cart_id"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "name"
    t.string   "email"
    t.date     "burthday"
    t.string   "hashed_pass"
    t.string   "salt"
    t.string   "secure_id"
    t.datetime "expired_at"
    t.string   "role"
    t.integer  "session_id"
  end

end
