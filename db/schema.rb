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

ActiveRecord::Schema.define(version: 20180107080943) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "employees", force: :cascade do |t|
    t.string "type"
    t.string "name"
    t.string "company_email"
    t.string "personal_email"
    t.string "id_number"
    t.date "birthday"
    t.string "bank_account"
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "extra_entries", force: :cascade do |t|
    t.string "title"
    t.integer "amount", default: 0
    t.integer "payroll_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "overtimes", force: :cascade do |t|
    t.date "date"
    t.string "rate"
    t.float "hours"
    t.integer "payroll_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payrolls", force: :cascade do |t|
    t.integer "year"
    t.integer "month"
    t.float "parttime_hours", default: 0.0
    t.float "leavetime_hours", default: 0.0
    t.float "sicktime_hours", default: 0.0
    t.float "vacation_refund_hours", default: 0.0
    t.integer "employee_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "salaries", force: :cascade do |t|
    t.boolean "monthly", default: true
    t.integer "base", default: 0
    t.date "start_date"
    t.integer "equipment_subsidy", default: 0
    t.integer "commuting_subsidy", default: 0
    t.integer "supervisor_allowance", default: 0
    t.integer "employee_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
