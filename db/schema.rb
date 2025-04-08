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

  create_table "customer_profiles", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.string "name", default: "", null: false
    t.string "phone_number", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_customer_profiles_on_customer_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "email", default: ""
    t.string "encrypted_password", default: ""
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_customers_on_confirmation_token", unique: true
    t.index ["reset_password_token"], name: "index_customers_on_reset_password_token", unique: true
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "sender_id", null: false
    t.bigint "receiver_id", null: false
    t.integer "status", null: false
    t.integer "notification_type", null: false
    t.text "message", null: false
    t.string "action_url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["receiver_id"], name: "index_notifications_on_receiver_id"
    t.index ["sender_id"], name: "index_notifications_on_sender_id"
  end

  create_table "reservation_details", force: :cascade do |t|
    t.bigint "reservation_id", null: false
    t.bigint "staff_id"
    t.bigint "service_menu_id", null: false
    t.string "menu_name", default: "", null: false
    t.integer "price", null: false
    t.integer "duration", null: false
    t.integer "required_staff_count"
    t.string "customer_name", default: "", null: false
    t.string "customer_phone_number", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reservation_id"], name: "index_reservation_details_on_reservation_id"
    t.index ["service_menu_id"], name: "index_reservation_details_on_service_menu_id"
    t.index ["staff_id"], name: "index_reservation_details_on_staff_id"
  end

  create_table "reservations", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.bigint "customer_id"
    t.string "public_id", null: false
    t.date "date", null: false
    t.time "start_time", null: false
    t.time "end_time", null: false
    t.string "customer_name", default: "", null: false
    t.string "customer_phone_number", default: "", null: false
    t.integer "total_price", null: false
    t.integer "total_duration", null: false
    t.text "menu_summary", default: "", null: false
    t.text "assigned_staff_names", default: "", null: false
    t.text "memo", default: "", null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_reservations_on_customer_id"
    t.index ["public_id"], name: "index_reservations_on_public_id", unique: true
    t.index ["team_id"], name: "index_reservations_on_team_id"
  end

  create_table "service_menu_staffs", force: :cascade do |t|
    t.bigint "service_menu_id", null: false
    t.bigint "staff_id", null: false
    t.integer "priority", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["service_menu_id"], name: "index_service_menu_staffs_on_service_menu_id"
    t.index ["staff_id", "service_menu_id"], name: "index_service_menu_staffs_on_staff_id_and_service_menu_id", unique: true
    t.index ["staff_id"], name: "index_service_menu_staffs_on_staff_id"
  end

  create_table "service_menus", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.string "menu_name", default: "", null: false
    t.integer "duration", default: 0, null: false
    t.integer "price", default: 0, null: false
    t.integer "required_staff_count", default: 1, null: false
    t.date "available_from", null: false
    t.date "available_until"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id", "menu_name"], name: "index_service_menus_on_team_id_and_menu_name", unique: true
    t.index ["team_id"], name: "index_service_menus_on_team_id"
  end

  create_table "staff_profiles", force: :cascade do |t|
    t.bigint "staff_id", null: false
    t.integer "working_status", default: 0, null: false
    t.string "nick_name", default: "", null: false
    t.string "profile_image", default: "", null: false
    t.boolean "accepts_direct_booking", default: false, null: false
    t.text "bio", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["staff_id"], name: "index_staff_profiles_on_staff_id"
  end

  create_table "staffs", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.integer "role", default: 1, null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_staffs_on_confirmation_token", unique: true
    t.index ["email"], name: "index_staffs_on_email", unique: true
    t.index ["invitation_token"], name: "index_staffs_on_invitation_token", unique: true
    t.index ["invited_by_id"], name: "index_staffs_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_staffs_on_invited_by"
    t.index ["reset_password_token"], name: "index_staffs_on_reset_password_token", unique: true
    t.index ["team_id"], name: "index_staffs_on_team_id"
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
    t.index ["name"], name: "index_teams_on_name", unique: true
    t.index ["permalink"], name: "index_teams_on_permalink", unique: true
  end

  add_foreign_key "customer_profiles", "customers"
  add_foreign_key "reservation_details", "reservations"
  add_foreign_key "reservation_details", "service_menus"
  add_foreign_key "reservation_details", "staffs"
  add_foreign_key "reservations", "customers"
  add_foreign_key "reservations", "teams"
  add_foreign_key "service_menu_staffs", "service_menus"
  add_foreign_key "service_menu_staffs", "staffs"
  add_foreign_key "service_menus", "teams"
  add_foreign_key "staff_profiles", "staffs"
  add_foreign_key "staffs", "teams"
  add_foreign_key "team_business_settings", "teams"
end
