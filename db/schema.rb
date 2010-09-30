# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100821143627) do

  create_table "actions", :force => true do |t|
    t.integer  "device_id",   :null => false
    t.integer  "command",     :null => false
    t.string   "action_type", :null => false
    t.integer  "range_min"
    t.integer  "range_max"
    t.string   "name"
    t.integer  "query_state", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "handle"
  end

  add_index "actions", ["device_id"], :name => "device_id"

  create_table "devices", :force => true do |t|
    t.integer  "house_id",       :null => false
    t.string   "device_class",   :null => false
    t.integer  "identification", :null => false
    t.string   "room",           :null => false
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "custom"
  end

  add_index "devices", ["house_id"], :name => "house_id"

  create_table "houses", :force => true do |t|
    t.integer  "user_id",     :null => false
    t.string   "name",        :null => false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "houses", ["user_id"], :name => "user_id"

  create_table "known_actions", :force => true do |t|
    t.integer "command",     :null => false
    t.string  "action_type", :null => false
    t.integer "query_state", :null => false
    t.text    "handle",      :null => false
  end

  create_table "known_devices", :force => true do |t|
    t.string "device_class", :null => false
    t.string "display_icon", :null => false
  end

  create_table "logs", :force => true do |t|
    t.integer  "user_id",                             :null => false
    t.integer  "loggable_id"
    t.string   "loggable_type", :default => "Action"
    t.text     "custom",                              :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "logs", ["user_id"], :name => "user_id"

  create_table "schedules", :force => true do |t|
    t.integer  "action_id",  :null => false
    t.text     "timing",     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "schedules", ["action_id"], :name => "action_id"

  create_table "tasks", :force => true do |t|
    t.integer  "key",                         :null => false
    t.integer  "house_id",                    :null => false
    t.text     "operation",                   :null => false
    t.string   "status",     :default => "N", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tasks", ["house_id"], :name => "house_id"
  add_index "tasks", ["key", "house_id", "status"], :name => "index_tasks_on_key_and_house_id_and_status", :unique => true

  create_table "users", :force => true do |t|
    t.string   "email",                              :null => false
    t.string   "username",                           :null => false
    t.string   "password",                           :null => false
    t.string   "name"
    t.boolean  "active",     :default => true,       :null => false
    t.string   "locale",     :default => "en",       :null => false
    t.string   "time_zone",  :default => "Brasilia", :null => false
    t.string   "style",      :default => "blue",     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_foreign_key "actions", "devices", :name => "actions_ibfk_1", :dependent => :delete

  add_foreign_key "devices", "houses", :name => "devices_ibfk_1", :dependent => :delete

  add_foreign_key "houses", "users", :name => "houses_ibfk_1", :dependent => :delete

  add_foreign_key "logs", "users", :name => "logs_ibfk_1", :dependent => :delete

  add_foreign_key "schedules", "actions", :name => "schedules_ibfk_1", :dependent => :delete

  add_foreign_key "tasks", "houses", :name => "tasks_ibfk_1", :dependent => :delete

end
