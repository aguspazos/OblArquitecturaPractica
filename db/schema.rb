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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171203222944) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cadet_shipments", force: :cascade do |t|
    t.bigint "cadet_id"
    t.bigint "shipment_id"
    t.boolean "sent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cadet_id"], name: "index_cadet_shipments_on_cadet_id"
    t.index ["shipment_id"], name: "index_cadet_shipments_on_shipment_id"
  end

  create_table "cadets", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "document"
    t.string "status"
    t.boolean "available"
    t.string "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password"
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.integer "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string "license_file_name"
    t.string "license_content_type"
    t.integer "license_file_size"
    t.datetime "license_updated_at"
    t.string "vehicle_documentation_file_name"
    t.string "vehicle_documentation_content_type"
    t.integer "vehicle_documentation_file_size"
    t.datetime "vehicle_documentation_updated_at"
  end

  create_table "estimated_prices", force: :cascade do |t|
    t.integer "user_id"
    t.integer "zone_price"
    t.integer "weight_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "final_zone_price"
    t.boolean "final_weight_price"
  end

  create_table "images", force: :cascade do |t|
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shipments", force: :cascade do |t|
    t.string "origin_lat"
    t.string "origin_lng"
    t.string "destiny_lat"
    t.string "destiny_lng"
    t.integer "sender_id"
    t.integer "receiver_id"
    t.string "receiver_email"
    t.float "price"
    t.boolean "final_price"
    t.integer "cadet_id"
    t.integer "status"
    t.boolean "sender_pays"
    t.boolean "receiver_pays"
    t.datetime "delivery_time"
    t.integer "payment_method"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "confirm_reception_file_name"
    t.string "confirm_reception_content_type"
    t.integer "confirm_reception_file_size"
    t.datetime "confirm_reception_updated_at"
    t.integer "weight"
  end

  create_table "user_discounts", force: :cascade do |t|
    t.integer "user_id"
    t.boolean "used"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "lastName"
    t.string "email"
    t.string "document"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.integer "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string "password"
  end

  add_foreign_key "cadet_shipments", "cadets"
  add_foreign_key "cadet_shipments", "shipments"
end
