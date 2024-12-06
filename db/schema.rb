# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2024_11_23_124817) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "announcements", force: :cascade do |t|
    t.string "announcement_type"
    t.string "country"
    t.string "city"
    t.date "date"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_announcements_on_user_id"
  end

  create_table "buy_for_mes", force: :cascade do |t|
    t.string "departure_country"
    t.string "departure_city"
    t.string "arrival_country"
    t.string "arrival_city"
    t.date "shopping_date"
    t.string "product_link"
    t.string "category"
    t.string "product_name"
    t.integer "product_quantity"
    t.string "parcel_type"
    t.decimal "product_price"
    t.decimal "buy_for_me_fee"
    t.decimal "total_price"
    t.string "shop_name"
    t.string "shop_address"
    t.string "buyer_name"
    t.string "buyer_contact_number"
    t.string "buyer_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_buy_for_mes_on_user_id"
  end

  create_table "chat_rooms", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "chat_rooms_users", id: false, force: :cascade do |t|
    t.bigint "chat_room_id", null: false
    t.bigint "user_id", null: false
    t.index ["chat_room_id", "user_id"], name: "index_chat_rooms_users_on_chat_room_id_and_user_id", unique: true
    t.index ["chat_room_id"], name: "index_chat_rooms_users_on_chat_room_id"
    t.index ["user_id"], name: "index_chat_rooms_users_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text "content"
    t.string "user"
    t.bigint "chat_room_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["chat_room_id"], name: "index_messages_on_chat_room_id"
  end

  create_table "packages", force: :cascade do |t|
    t.string "sender_name"
    t.string "destination_country"
    t.string "destination_city"
    t.date "expected_delivery_date"
    t.bigint "traveler_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["traveler_id"], name: "index_packages_on_traveler_id"
  end

  create_table "parcel_ads", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "departure_city"
    t.string "arrival_city"
    t.string "departure_country"
    t.string "arrival_country"
    t.date "shipment_date"
    t.string "parcel_type"
    t.string "parcel_length"
    t.string "parcel_width"
    t.string "parcel_height"
    t.integer "parcel_quantity"
    t.boolean "insure_shipment"
    t.text "description"
    t.decimal "bonus"
    t.string "service_type"
    t.decimal "recommended_fee"
    t.decimal "proposed_fee"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "label_url"
    t.string "shipment_id"
    t.string "rate_id"
    t.integer "parcel_weight"
    t.index ["user_id"], name: "index_parcel_ads_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "reviewer_id"
    t.integer "reviewee_id"
    t.integer "rating"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "comment_label"
    t.text "custom_comment"
  end

  create_table "travelers", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.date "travel_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "trip_type"
    t.string "departure_country"
    t.string "departure_city"
    t.string "arrival_country"
    t.string "arrival_city"
    t.string "transportation"
    t.string "parcel_type"
    t.integer "parcel_qty"
    t.boolean "ready_to_buy_for_you"
    t.string "parcel_collection_mode"
    t.date "travel_return_date"
    t.bigint "user_id"
    t.index ["user_id"], name: "index_travelers_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "phone_number"
    t.string "city"
    t.string "country"
    t.string "postal_code"
    t.string "uid"
    t.string "provider"
    t.string "profile_picture"
    t.string "address_1"
    t.string "address_2"
    t.string "user_type", default: "individual", null: false
    t.string "verification_code"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "announcements", "users"
  add_foreign_key "buy_for_mes", "users"
  add_foreign_key "chat_rooms_users", "chat_rooms"
  add_foreign_key "chat_rooms_users", "users"
  add_foreign_key "messages", "chat_rooms"
  add_foreign_key "packages", "travelers"
  add_foreign_key "parcel_ads", "users"
  add_foreign_key "travelers", "users"
end
