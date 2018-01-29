FactoryBot.define do
  factory :salary do
    role "regular"
    effective_date do |salary|
      salary.employee.start_date
    end
  end
end
