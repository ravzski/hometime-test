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

ActiveRecord::Schema[7.0].define(version: 2023_01_30_192242) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "guests", force: :cascade do |t|
    t.string "first_name"
    t.string "localized_description"
    t.string "last_name"
    t.string "phone_numbers", default: [], array: true
    t.string "email"
    t.integer "reservation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_guests_on_email", unique: true
    t.index ["reservation_id"], name: "index_guests_on_reservation_id", unique: true
  end

  create_table "reservation_status_events", force: :cascade do |t|
    t.string "status"
    t.text "remarks"
    t.integer "reservation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reservation_id"], name: "index_reservation_status_events_on_reservation_id"
  end

  create_table "reservation_status_settings", force: :cascade do |t|
    t.string "name"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reservations", force: :cascade do |t|
    t.string "code"
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer "nights"
    t.integer "adults"
    t.integer "children"
    t.integer "infants"
    t.integer "guests"
    t.decimal "security_price", precision: 10, scale: 2
    t.decimal "total_price", precision: 10, scale: 2
    t.decimal "payout_price", precision: 10, scale: 2
    t.integer "active_status_event_id"
    t.string "currency"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active_status_event_id"], name: "index_reservations_on_active_status_event_id"
    t.index ["code"], name: "index_reservations_on_code", unique: true
  end

end
