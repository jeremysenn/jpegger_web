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

ActiveRecord::Schema.define(version: 2019_06_28_143901) do

  create_table "companies", force: :cascade do |t|
    t.string "name", null: false
    t.string "phone"
    t.string "jpegger_service_ip", null: false
    t.string "jpegger_service_port", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "image_files", force: :cascade do |t|
    t.string "name"
    t.string "file"
    t.integer "user_id"
    t.string "ticket_number"
    t.string "customer_number"
    t.string "customer_name"
    t.string "branch_code"
    t.string "location"
    t.string "event_code"
    t.integer "event_code_id"
    t.integer "image_id"
    t.string "container_number"
    t.string "booking_number"
    t.string "contract_number"
    t.boolean "hidden"
    t.string "tare_seq_nbr"
    t.string "commodity_name"
    t.decimal "weight"
    t.string "tag_number"
    t.string "vin_number"
    t.string "yard_id"
    t.string "contract_verbiage"
    t.string "service_request_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name"
    t.string "last_name"
    t.integer "company_id"
    t.string "role"
    t.boolean "active"
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
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "customer_name"
    t.string "temporary_password"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
