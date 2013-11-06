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

ActiveRecord::Schema.define(:version => 20131106220614) do

  create_table "bill_splits", :force => true do |t|
    t.integer  "bill_id",    :null => false
    t.integer  "debtor_id",  :null => false
    t.integer  "amount",     :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "bill_splits", ["bill_id"], :name => "index_bill_splits_on_bill_id"
  add_index "bill_splits", ["debtor_id"], :name => "index_bill_splits_on_debtor_id"

  create_table "bills", :force => true do |t|
    t.integer  "owner_id",    :null => false
    t.integer  "total"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.boolean  "settling"
  end

  add_index "bills", ["owner_id"], :name => "index_bills_on_owner_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email",           :null => false
    t.string   "password_digest", :null => false
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "session_token"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["session_token"], :name => "index_users_on_session_token"

end
