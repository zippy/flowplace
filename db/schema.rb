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

ActiveRecord::Schema.define(:version => 20110302202041) do

  create_table "activities", :force => true do |t|
    t.integer  "user_id"
    t.string   "type"
    t.string   "activityable_type"
    t.integer  "activityable_id"
    t.text     "contents"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "allowances", :force => true do |t|
    t.integer "role_id"
    t.integer "permission_id"
    t.integer "allowance",     :default => 1
  end

  add_index "allowances", ["role_id"], :name => "index_allowances_on_role_id"

  create_table "annotations", :force => true do |t|
    t.text     "body"
    t.string   "path"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "revisable_original_id"
    t.integer  "revisable_branched_from_id"
    t.integer  "revisable_number"
    t.string   "revisable_name"
    t.string   "revisable_type"
    t.datetime "revisable_current_at"
    t.datetime "revisable_revised_at"
    t.datetime "revisable_deleted_at"
    t.boolean  "revisable_is_current"
  end

  create_table "configurations", :force => true do |t|
    t.string   "name"
    t.string   "configuration_type"
    t.text     "value"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "sequence"
  end

  create_table "currencies", :force => true do |t|
    t.string   "name"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "icon_url"
    t.string   "symbol"
    t.text     "description"
    t.text     "agreement"
    t.text     "config"
    t.integer  "steward_id"
  end

  create_table "currency_accounts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "currency_id"
    t.text     "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "player_class"
    t.string   "name"
    t.string   "notification"
  end

  create_table "currency_weal_links", :force => true do |t|
    t.integer "currency_id"
    t.integer "weal_id"
    t.text    "link_spec"
  end

  create_table "identities", :force => true do |t|
    t.string   "user_name"
    t.string   "openid_url"
    t.string   "password_salt"
    t.string   "password_hash"
    t.string   "activation_code"
    t.string   "reset_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "enabled",         :default => true
  end

  add_index "identities", ["activation_code"], :name => "index_identities_on_activation_code"
  add_index "identities", ["reset_code"], :name => "index_identities_on_reset_code"
  add_index "identities", ["user_name"], :name => "index_identities_on_user_name", :unique => true

  create_table "permissions", :force => true do |t|
    t.string "name"
    t.string "description"
  end

  add_index "permissions", ["name"], :name => "index_permissions_on_name", :unique => true

  create_table "play_currency_account_links", :force => true do |t|
    t.integer "currency_account_id"
    t.integer "play_id"
    t.string  "field_name"
  end

  create_table "plays", :force => true do |t|
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "proposals", :force => true do |t|
    t.integer  "user_id"
    t.text     "description"
    t.string   "as"
    t.integer  "weal_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string "name"
    t.string "description"
  end

  add_index "roles", ["name"], :name => "index_roles_on_name", :unique => true

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  add_index "roles_users", ["role_id"], :name => "index_roles_users_on_role_id"
  add_index "roles_users", ["user_id"], :name => "index_roles_users_on_user_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "taggable_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string   "user_name"
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at"
    t.datetime "last_sign_in_at"
    t.string   "last_sign_in_ip"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "phone"
    t.string   "phone2"
    t.string   "fax"
    t.string   "country"
    t.text     "notes"
    t.string   "preferences"
    t.string   "time_zone"
    t.string   "time_local"
    t.string   "timezone_offset"
    t.integer  "bolt_identity_id"
    t.integer  "circle_id"
    t.string   "language"
    t.text     "privs"
    t.boolean  "enabled"
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "password_salt",                       :default => "", :null => false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.string   "current_sign_in_ip"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "users_bak", :force => true do |t|
    t.string   "user_name"
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at"
    t.datetime "last_login"
    t.string   "last_login_ip"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "phone"
    t.string   "phone2"
    t.string   "fax"
    t.string   "country"
    t.text     "notes"
    t.string   "preferences"
    t.string   "time_zone"
    t.string   "time_local"
    t.string   "timezone_offset"
    t.integer  "bolt_identity_id"
    t.integer  "circle_id"
    t.string   "language"
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "password_salt",                       :default => "", :null => false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.text     "privs"
    t.boolean  "enabled"
  end

  create_table "wallets", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "weals", :force => true do |t|
    t.string   "title"
    t.string   "phase"
    t.text     "description"
    t.integer  "requester_id"
    t.integer  "offerer_id"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.boolean  "created_by_requester", :default => true, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "in_service_of"
    t.text     "notes"
    t.integer  "circle_id"
  end

end
