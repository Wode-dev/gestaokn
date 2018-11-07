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

ActiveRecord::Schema.define(version: 2018_11_07_205811) do

  create_table "bills", force: :cascade do |t|
    t.integer "secret_id"
    t.decimal "value"
    t.string "reference"
    t.text "note"
    t.date "due_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "plans", force: :cascade do |t|
    t.string "rate_limit"
    t.decimal "value"
    t.string "profile_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "secrets", force: :cascade do |t|
    t.string "name"
    t.text "address"
    t.string "city"
    t.string "state"
    t.string "neighborhood"
    t.string "doc_name"
    t.string "doc_value"
    t.string "secret"
    t.string "secret_password"
    t.string "wireless_ssid"
    t.string "wireless_password"
    t.string "due_date"
    t.integer "plan_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "enabled"
    t.string "service"
    t.string "remote_address"
    t.string "local_address"
    t.date "instalation"
  end

end
