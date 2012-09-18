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

ActiveRecord::Schema.define(:version => 10) do

  create_table "members", :force => true do |t|
    t.string   "system_name"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "encrypted_password"
    t.text     "description"
    t.integer  "balance_id"
    t.integer  "ranking"
    t.integer  "status_id"
    t.integer  "memberships_member_id"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  create_table "members_status_logs", :id => false, :force => true do |t|
    t.integer "member_id"
    t.integer "status_log_id"
  end

  create_table "status_logs", :force => true do |t|
    t.integer  "status_id"
    t.integer  "member_id"
    t.integer  "new_status_id"
    t.text     "description"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "status_machines", :force => true do |t|
    t.string   "system_name"
    t.string   "readable_name"
    t.text     "description"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "status_machines_statuses", :force => true do |t|
    t.integer  "status_machine_id"
    t.integer  "status_id"
    t.integer  "step"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "statuses", :force => true do |t|
    t.string   "system_name"
    t.string   "readable_name"
    t.text     "description"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

end
