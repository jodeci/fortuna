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

ActiveRecord::Schema.define(version: 2018_11_19_082055) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "corrections", force: :cascade do |t|
    t.integer "statement_id"
    t.integer "amount", default: 0
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["statement_id"], name: "index_corrections_on_statement_id"
  end

  create_table "employees", force: :cascade do |t|
    t.string "name"
    t.string "company_email"
    t.string "personal_email"
    t.string "id_number"
    t.string "residence_address"
    t.date "birthday"
    t.string "bank_account"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "bank_transfer_type", default: "salary"
    t.boolean "b2b", default: false
    t.boolean "owner", default: false
  end

  create_table "extra_entries", force: :cascade do |t|
    t.string "title"
    t.integer "amount", default: 0
    t.string "note"
    t.integer "payroll_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "income_type", default: "salary"
    t.index ["payroll_id"], name: "index_extra_entries_on_payroll_id"
  end

  create_table "overtimes", force: :cascade do |t|
    t.date "date"
    t.string "rate"
    t.decimal "hours", default: "0.0"
    t.integer "payroll_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["payroll_id"], name: "index_overtimes_on_payroll_id"
  end

  create_table "payrolls", force: :cascade do |t|
    t.integer "year"
    t.integer "month"
    t.decimal "parttime_hours", default: "0.0"
    t.decimal "leavetime_hours", default: "0.0"
    t.decimal "sicktime_hours", default: "0.0"
    t.decimal "vacation_refund_hours", default: "0.0"
    t.integer "employee_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "salary_id"
    t.integer "festival_bonus", default: 0
    t.string "festival_type"
    t.index ["employee_id"], name: "index_payrolls_on_employee_id"
    t.index ["month"], name: "index_payrolls_on_month"
    t.index ["salary_id"], name: "index_payrolls_on_salary_id"
    t.index ["year"], name: "index_payrolls_on_year"
  end

  create_table "salaries", force: :cascade do |t|
    t.string "role"
    t.string "tax_code", default: "50"
    t.integer "monthly_wage", default: 0
    t.integer "hourly_wage", default: 0
    t.date "effective_date"
    t.integer "equipment_subsidy", default: 0
    t.integer "commuting_subsidy", default: 0
    t.integer "supervisor_allowance", default: 0
    t.integer "labor_insurance", default: 0
    t.integer "health_insurance", default: 0
    t.integer "employee_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "insured_for_health", default: 0
    t.integer "insured_for_labor", default: 0
    t.string "cycle", default: "normal"
    t.decimal "monthly_wage_adjustment", default: "1.0"
    t.index ["effective_date"], name: "index_salaries_on_effective_date"
    t.index ["employee_id"], name: "index_salaries_on_employee_id"
  end

  create_table "statements", force: :cascade do |t|
    t.integer "amount", default: 0
    t.integer "year"
    t.integer "month"
    t.integer "splits", array: true
    t.integer "payroll_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "subsidy_income", default: 0
    t.integer "excess_income", default: 0
    t.index ["payroll_id"], name: "index_statements_on_payroll_id"
  end

  create_table "terms", force: :cascade do |t|
    t.date "start_date"
    t.date "end_date"
    t.integer "employee_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_terms_on_employee_id"
    t.index ["end_date"], name: "index_terms_on_end_date"
    t.index ["start_date"], name: "index_terms_on_start_date"
  end


  create_view "reports",  sql_definition: <<-SQL
      SELECT DISTINCT employees.id AS employee_id,
      payrolls.id AS payroll_id,
      employees.name,
      employees.id_number,
      employees.residence_address,
      payrolls.year,
      payrolls.month,
      salaries.tax_code,
      statements.amount,
      statements.subsidy_income,
      payrolls.festival_bonus,
      payrolls.festival_type,
      sum(corrections.amount) AS correction
     FROM ((((employees
       JOIN payrolls ON ((employees.id = payrolls.employee_id)))
       JOIN salaries ON ((salaries.id = payrolls.salary_id)))
       JOIN statements ON ((payrolls.id = statements.payroll_id)))
       LEFT JOIN corrections ON ((statements.id = corrections.statement_id)))
    WHERE (employees.b2b = false)
    GROUP BY employees.id, payrolls.id, statements.id, salaries.tax_code;
  SQL

  create_view "payroll_details",  sql_definition: <<-SQL
      SELECT DISTINCT employees.id AS employee_id,
      payrolls.id AS payroll_id,
      payrolls.year,
      payrolls.month,
      salaries.tax_code,
      salaries.monthly_wage,
      salaries.insured_for_health,
      statements.splits,
      statements.amount,
      statements.subsidy_income,
      statements.excess_income,
      employees.owner
     FROM (((employees
       JOIN payrolls ON ((employees.id = payrolls.employee_id)))
       JOIN salaries ON ((salaries.id = payrolls.salary_id)))
       JOIN statements ON ((payrolls.id = statements.payroll_id)))
    WHERE (employees.b2b = false);
  SQL

end
