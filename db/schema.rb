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

ActiveRecord::Schema.define(:version => 20120422064751) do

  create_table "holidays", :force => true do |t|
    t.integer  "day"
    t.string   "wday"
    t.integer  "month"
    t.integer  "year"
    t.string   "reason"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "leaves", :force => true do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "total_days"
    t.text     "reason_for_leave"
    t.integer  "user_id"
    t.integer  "manager_id"
    t.string   "status"
    t.text     "reason_for_rejection"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.integer  "level"
    t.integer  "band"
    t.integer  "min_salary"
    t.integer  "max_salary"
    t.integer  "paid_leaves"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "password"
    t.string   "confirm_password"
    t.integer  "manager_id"
    t.integer  "role_id"
    t.date     "joining_date"
    t.date     "end_date"
    t.integer  "salary"
    t.integer  "remaining_leaves"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end