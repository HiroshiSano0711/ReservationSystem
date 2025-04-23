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

ActiveRecord::Schema[8.0].define(version: 2025_04_17_164239) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

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

  create_table "customer_profiles", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.string "name", default: "", null: false, comment: "名前"
    t.string "phone_number", default: "", null: false, comment: "電話番号"
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
    t.index ["email"], name: "index_customers_on_email", unique: true
    t.index ["invitation_token"], name: "index_customers_on_invitation_token", unique: true
    t.index ["invited_by_id"], name: "index_customers_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_customers_on_invited_by"
    t.index ["reset_password_token"], name: "index_customers_on_reset_password_token", unique: true
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.bigint "reservation_id", null: false
    t.bigint "receiver_id", null: false, comment: "受信者（Staff）"
    t.boolean "is_read", default: false, null: false, comment: "既読か未読か"
    t.integer "notification_type", null: false, comment: "タイプ"
    t.string "action_url", null: false, comment: "アクションURL"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["receiver_id"], name: "index_notifications_on_receiver_id"
    t.index ["reservation_id"], name: "index_notifications_on_reservation_id"
    t.index ["team_id"], name: "index_notifications_on_team_id"
  end

  create_table "reservation_details", force: :cascade do |t|
    t.bigint "reservation_id", null: false
    t.bigint "staff_id"
    t.bigint "service_menu_id", null: false
    t.string "menu_name", default: "", null: false, comment: "メニュー名"
    t.integer "price", null: false, comment: "価格"
    t.integer "duration", null: false, comment: "所要時間"
    t.integer "required_staff_count", null: false, comment: "所要人数"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reservation_id"], name: "index_reservation_details_on_reservation_id"
    t.index ["service_menu_id"], name: "index_reservation_details_on_service_menu_id"
    t.index ["staff_id"], name: "index_reservation_details_on_staff_id"
  end

  create_table "reservations", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.bigint "customer_id"
    t.string "public_id", null: false, comment: "予約ID（公開用）"
    t.date "date", null: false, comment: "予約日"
    t.time "start_time", null: false, comment: "開始時間"
    t.time "end_time", null: false, comment: "終了時間"
    t.string "customer_name", default: "", null: false, comment: "顧客名"
    t.string "customer_phone_number", default: "", null: false, comment: "電話番号"
    t.integer "total_price", null: false, comment: "合計価格"
    t.integer "total_duration", null: false, comment: "合計所要時間"
    t.integer "required_staff_count", null: false, comment: "合計所要人数"
    t.text "menu_summary", default: "", null: false, comment: "メニュー"
    t.string "assigned_staff_name", default: "", null: false, comment: "担当者名"
    t.integer "status", default: 0, null: false, comment: "ステータス"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_reservations_on_customer_id"
    t.index ["public_id"], name: "index_reservations_on_public_id", unique: true
    t.index ["team_id"], name: "index_reservations_on_team_id"
  end

  create_table "service_menu_staffs", force: :cascade do |t|
    t.bigint "service_menu_id", null: false
    t.bigint "staff_id", null: false
    t.integer "priority", default: 0, null: false, comment: "優先度"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["service_menu_id"], name: "index_service_menu_staffs_on_service_menu_id"
    t.index ["staff_id", "service_menu_id"], name: "index_service_menu_staffs_on_staff_id_and_service_menu_id", unique: true
    t.index ["staff_id"], name: "index_service_menu_staffs_on_staff_id"
  end

  create_table "service_menus", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.string "menu_name", default: "", null: false, comment: "メニュー名"
    t.integer "duration", default: 0, null: false, comment: "所要時間"
    t.integer "price", default: 0, null: false, comment: "価格（税込）"
    t.integer "required_staff_count", default: 1, null: false, comment: "所要人数"
    t.datetime "available_from", null: false, comment: "提供開始日"
    t.datetime "available_until", comment: "提供終了日"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id", "menu_name"], name: "index_service_menus_on_team_id_and_menu_name", unique: true
    t.index ["team_id"], name: "index_service_menus_on_team_id"
  end

  create_table "staff_profiles", force: :cascade do |t|
    t.bigint "staff_id", null: false
    t.integer "working_status", default: 0, null: false, comment: "勤務状況"
    t.string "nick_name", default: "", null: false, comment: "ニックネーム"
    t.boolean "accepts_direct_booking", default: false, null: false, comment: "指名受付"
    t.text "bio", default: "", null: false, comment: "自己紹介"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["staff_id"], name: "index_staff_profiles_on_staff_id"
  end

  create_table "staffs", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.integer "role", default: 1, null: false, comment: "ロール"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
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
    t.index ["email"], name: "index_staffs_on_email", unique: true
    t.index ["invitation_token"], name: "index_staffs_on_invitation_token", unique: true
    t.index ["invited_by_id"], name: "index_staffs_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_staffs_on_invited_by"
    t.index ["reset_password_token"], name: "index_staffs_on_reset_password_token", unique: true
    t.index ["team_id"], name: "index_staffs_on_team_id"
  end

  create_table "team_business_settings", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.integer "max_reservation_month", null: false, comment: "最大受付月数"
    t.integer "reservation_start_delay_days", default: 0, null: false, comment: "予約受付猶予（日数）"
    t.integer "cancellation_deadline_hours_before", default: 24, null: false, comment: "予約キャンセル期限（時間）"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_team_business_settings_on_team_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name", null: false, comment: "チーム名"
    t.string "permalink", null: false, comment: "予約URL"
    t.text "description", comment: "概要"
    t.string "phone_number", comment: "電話番号"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_teams_on_name", unique: true
    t.index ["permalink"], name: "index_teams_on_permalink", unique: true
  end

  create_table "weekly_business_hours", force: :cascade do |t|
    t.bigint "team_business_setting_id", null: false
    t.integer "wday", null: false, comment: "曜日"
    t.boolean "working_day", default: true, null: false, comment: "営業日か休日か"
    t.time "open", null: false, comment: "オープン"
    t.time "close", null: false, comment: "クローズ"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_business_setting_id", "wday"], name: "idx_on_team_business_setting_id_wday_07303326f0", unique: true
    t.index ["team_business_setting_id"], name: "index_weekly_business_hours_on_team_business_setting_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "customer_profiles", "customers"
  add_foreign_key "notifications", "reservations"
  add_foreign_key "notifications", "staffs", column: "receiver_id"
  add_foreign_key "notifications", "teams"
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
  add_foreign_key "weekly_business_hours", "team_business_settings"
end
