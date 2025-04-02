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

ActiveRecord::Schema[8.0].define(version: 2025_04_01_091211) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "notifications", force: :cascade do |t|
    t.bigint "sender", null: false
    t.bigint "receiver", null: false
    t.integer "status", null: false
    t.integer "notification_type", null: false
    t.text "message", null: false
    t.string "action_url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reservation_details", force: :cascade do |t|
    t.bigint "reservation_id", null: false
    t.integer "price", null: false
    t.integer "duration", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reservation_id"], name: "index_reservation_details_on_reservation_id"
  end

  create_table "reservations", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.bigint "customer_id"
    t.string "public_id"
    t.string "customer_name"
    t.string "customer_phone_number"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_reservations_on_customer_id"
    t.index ["team_id"], name: "index_reservations_on_team_id"
  end

  create_table "reservatoin_detail_users", force: :cascade do |t|
    t.bigint "reservation_detail_id", null: false
    t.bigint "service_menu_user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reservation_detail_id"], name: "index_reservatoin_detail_users_on_reservation_detail_id"
    t.index ["service_menu_user_id"], name: "index_reservatoin_detail_users_on_service_menu_user_id"
  end

  create_table "service_menu_users", force: :cascade do |t|
    t.bigint "service_menu_id", null: false
    t.bigint "user_id", null: false
    t.integer "priority", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["service_menu_id"], name: "index_service_menu_users_on_service_menu_id"
    t.index ["user_id"], name: "index_service_menu_users_on_user_id"
  end

  create_table "service_menus", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.string "menu_name", null: false
    t.integer "duration", null: false
    t.integer "price", null: false
    t.integer "required_staff_count", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_service_menus_on_team_id"
  end

  create_table "team_business_settings", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.jsonb "business_hours_for_day_of_week", null: false
    t.integer "max_reservation_month", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_team_business_settings_on_team_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name", null: false
    t.string "permalink", null: false
    t.text "description"
    t.string "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.integer "role", default: 1, null: false
    t.string "nick_name", null: false
    t.string "profile_image"
    t.integer "status", null: false
    t.boolean "accepts_direct_booking", default: false, null: false
    t.text "bio"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["team_id"], name: "index_users_on_team_id"
  end

  add_foreign_key "reservation_details", "reservations"
  add_foreign_key "reservations", "teams"
  add_foreign_key "reservatoin_detail_users", "reservation_details"
  add_foreign_key "reservatoin_detail_users", "service_menu_users"
  add_foreign_key "service_menu_users", "service_menus"
  add_foreign_key "service_menu_users", "users"
  add_foreign_key "service_menus", "teams"
  add_foreign_key "team_business_settings", "teams"
  add_foreign_key "users", "teams"
end
