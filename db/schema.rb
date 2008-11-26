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

ActiveRecord::Schema.define(:version => 20080101010107) do

  create_table "cities", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.string   "name",                      :null => false
    t.float    "latitude"
    t.float    "longitude"
    t.string   "province_id",  :limit => 6
    t.string   "country_id",   :limit => 2, :null => false
    t.string   "airport_code", :limit => 3
    t.integer  "population"
    t.integer  "area"
  end

  add_index "cities", ["airport_code"], :name => "index_cities_on_airport_code"
  add_index "cities", ["area"], :name => "index_cities_on_area"
  add_index "cities", ["country_id"], :name => "index_cities_on_country_id"
  add_index "cities", ["latitude"], :name => "index_cities_on_latitude"
  add_index "cities", ["longitude"], :name => "index_cities_on_longitude"
  add_index "cities", ["name"], :name => "index_cities_on_name"
  add_index "cities", ["population"], :name => "index_cities_on_population"
  add_index "cities", ["province_id"], :name => "index_cities_on_province_id"

  create_table "countries", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.string   "name",       :null => false
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "population"
    t.integer  "area"
  end

  add_index "countries", ["area"], :name => "index_countries_on_area"
  add_index "countries", ["latitude"], :name => "index_countries_on_latitude"
  add_index "countries", ["longitude"], :name => "index_countries_on_longitude"
  add_index "countries", ["name"], :name => "index_countries_on_name"
  add_index "countries", ["population"], :name => "index_countries_on_population"

  create_table "neighborhoods", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.string   "name"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "population"
    t.integer  "city_id"
  end

  add_index "neighborhoods", ["city_id"], :name => "index_neighborhoods_on_city_id"
  add_index "neighborhoods", ["latitude"], :name => "index_neighborhoods_on_latitude"
  add_index "neighborhoods", ["longitude"], :name => "index_neighborhoods_on_longitude"
  add_index "neighborhoods", ["name"], :name => "index_neighborhoods_on_name"
  add_index "neighborhoods", ["population"], :name => "index_neighborhoods_on_population"

  create_table "provinces", :force => true do |t|
    t.string   "country_id", :limit => 2, :null => false
    t.string   "code",       :limit => 3
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.string   "name",                    :null => false
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "population"
    t.integer  "area"
  end

  add_index "provinces", ["area"], :name => "index_provinces_on_area"
  add_index "provinces", ["code"], :name => "index_provinces_on_code"
  add_index "provinces", ["country_id"], :name => "index_provinces_on_country_id"
  add_index "provinces", ["latitude"], :name => "index_provinces_on_latitude"
  add_index "provinces", ["longitude"], :name => "index_provinces_on_longitude"
  add_index "provinces", ["name"], :name => "index_provinces_on_name"
  add_index "provinces", ["population"], :name => "index_provinces_on_population"

  create_table "roles", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.string   "name"
  end

  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "users", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "nickname"
  end

  add_index "users", ["first_name"], :name => "index_users_on_first_name"
  add_index "users", ["last_name"], :name => "index_users_on_last_name"
  add_index "users", ["middle_name"], :name => "index_users_on_middle_name"
  add_index "users", ["nickname"], :name => "index_users_on_nickname"

  create_table "users_roles", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.string   "user_id"
    t.string   "role_id"
  end

  add_index "users_roles", ["role_id"], :name => "index_users_roles_on_role_id"
  add_index "users_roles", ["user_id"], :name => "index_users_roles_on_user_id"

end
