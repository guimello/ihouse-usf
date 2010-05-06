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

ActiveRecord::Schema.define(:version => 20100505180408) do

  create_table "actions", :force => true do |t|
    t.integer  "device_id",        :null => false
    t.integer  "voice_command_id"
    t.string   "command",          :null => false
    t.string   "action_type",      :null => false
    t.integer  "range_min"
    t.integer  "range_max"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "known_action_id"
  end

  add_index "actions", ["device_id"], :name => "device_id"
  add_index "actions", ["known_action_id"], :name => "actions_known_action_id_fk"
  add_index "actions", ["voice_command_id"], :name => "voice_command_id"

  create_table "devices", :force => true do |t|
    t.integer  "house_id",        :null => false
    t.string   "device_class",    :null => false
    t.string   "identification",  :null => false
    t.string   "room",            :null => false
    t.string   "name"
    t.string   "query_state",     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "known_device_id"
  end

  add_index "devices", ["house_id"], :name => "house_id"
  add_index "devices", ["known_device_id"], :name => "devices_known_device_id_fk"

  create_table "houses", :force => true do |t|
    t.integer  "user_id",     :null => false
    t.string   "name",        :null => false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "houses", ["user_id"], :name => "user_id"

  create_table "known_actions", :force => true do |t|
    t.string "command",     :null => false
    t.string "action_type", :null => false
    t.text   "handle",      :null => false
  end

  create_table "known_devices", :force => true do |t|
    t.string "device_class", :null => false
    t.string "query_state",  :null => false
    t.string "display_icon", :null => false
  end

  create_table "logs", :force => true do |t|
    t.integer  "house_id",                            :null => false
    t.integer  "loggable_id"
    t.string   "loggable_type", :default => "Action"
    t.string   "action",                              :null => false
    t.datetime "created_at",                          :null => false
  end

  add_index "logs", ["house_id"], :name => "house_id"

  create_table "schedules", :force => true do |t|
    t.integer  "action_id",  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "schedules", ["action_id"], :name => "action_id"

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

  create_table "voice_commands", :force => true do |t|
    t.string   "speak",      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_foreign_key "actions", "devices", :name => "actions_ibfk_1", :dependent => :delete
  add_foreign_key "actions", "known_actions", :name => "actions_known_action_id_fk", :dependent => :delete
  add_foreign_key "actions", "voice_commands", :name => "actions_ibfk_2", :dependent => :nullify

  add_foreign_key "devices", "houses", :name => "devices_ibfk_1", :dependent => :delete
  add_foreign_key "devices", "known_devices", :name => "devices_known_device_id_fk", :dependent => :delete

  add_foreign_key "houses", "users", :name => "houses_ibfk_1", :dependent => :delete

  add_foreign_key "logs", "houses", :name => "logs_ibfk_1", :dependent => :delete

  add_foreign_key "schedules", "actions", :name => "schedules_ibfk_1", :dependent => :delete

end
