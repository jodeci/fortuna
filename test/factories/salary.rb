# frozen_string_literal: true

FactoryBot.define do
  factory :salary do
    role "regular"
    effective_date do |salary|
      salary.employee.start_date if salary.employee
    end
  end
end
