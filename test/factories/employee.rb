# frozen_string_literal: true
FactoryBot.define do
  factory :employee do
    factory :fulltime_employee do
      name { "John Doe" }
      type { "fulltime" }

      after(:create) do |employee|
        create(:salary, base: 36000, start_date: "2015-05-13", employee: employee)
        create(:salary, base: 40000, start_date: "2015-09-01", employee: employee)
        create(:salary, base: 50000, start_date: "2016-03-01", employee: employee)
      end
    end
  end
end
