# frozen_string_literal: true
FactoryBot.define do
  factory :fulltime_salary do
    base { 30000 }
    start_date { "2015-05-13" }
    equipment_subsidy { 800 }
    fulltime_employee
  end
end
