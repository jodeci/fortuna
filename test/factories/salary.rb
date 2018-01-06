# frozen_string_literal: true
FactoryBot.define do
  factory :fulltime_salary, class: Salary do
    association :employee, factory: :fulltime_employee
    base { 36000 }
    start_date { "2015-05-13" }
    equipment_subsidy { 800 }
  end
end
