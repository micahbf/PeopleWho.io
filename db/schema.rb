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

ActiveRecord::Schema.define(:version => 20131113223954) do

  create_table "bill_splits", :force => true do |t|
    t.integer  "bill_id",     :null => false
    t.integer  "debtor_id",   :null => false
    t.integer  "amount",      :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "orig_amount"
  end

  add_index "bill_splits", ["bill_id"], :name => "index_bill_splits_on_bill_id"
  add_index "bill_splits", ["debtor_id"], :name => "index_bill_splits_on_debtor_id"

  create_table "bills", :force => true do |t|
    t.integer  "owner_id",            :null => false
    t.integer  "total"
    t.string   "description"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.boolean  "settling"
    t.integer  "group_id"
    t.string   "orig_currency_code"
    t.integer  "orig_currency_total"
  end

  add_index "bills", ["group_id"], :name => "index_bills_on_group_id"
  add_index "bills", ["owner_id"], :name => "index_bills_on_owner_id"

  create_table "currencies", :force => true do |t|
    t.string   "code",       :null => false
    t.string   "full_name",  :null => false
    t.float    "rate",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "currencies", ["code"], :name => "index_currencies_on_code", :unique => true

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0, :null => false
    t.integer  "attempts",   :default => 0, :null => false
    t.text     "handler",                   :null => false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "user_group_memberships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "user_group_memberships", ["group_id"], :name => "index_user_group_memberships_on_group_id"
  add_index "user_group_memberships", ["user_id"], :name => "index_user_group_memberships_on_user_id"

  create_table "user_groups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email",                              :null => false
    t.string   "password_digest",                    :null => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "session_token"
    t.boolean  "is_stub",         :default => false, :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["session_token"], :name => "index_users_on_session_token"

end
