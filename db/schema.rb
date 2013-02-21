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

ActiveRecord::Schema.define(:version => 20130221160828) do

  create_table "households", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "head_id",    :null => false
  end

  add_index "households", ["head_id"], :name => "index_households_on_head_id"
  add_index "households", ["name"], :name => "index_households_on_name"

  create_table "users", :force => true do |t|
    t.string   "username",                                            :null => false
    t.string   "email",                                               :null => false
    t.string   "crypted_password",                                    :null => false
    t.string   "salt",                                                :null => false
    t.datetime "created_at",                                          :null => false
    t.datetime "updated_at",                                          :null => false
    t.string   "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.string   "role",                            :default => "user"
    t.string   "full_name"
    t.integer  "household_id"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["household_id"], :name => "index_users_on_household_id"
  add_index "users", ["remember_me_token"], :name => "index_users_on_remember_me_token"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token"
  add_index "users", ["role"], :name => "index_users_on_role"
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

end
