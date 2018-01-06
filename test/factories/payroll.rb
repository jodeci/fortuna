# frozen_string_literal: true
FactoryBot.define do
  factory :fulltime_payroll, class: Payroll do
    association :employee, factory: :fulltime_employee

    factory :initial_month do
      year { 2015 }
      month { 5 }
    end

    factory :normal_month do
      year { 2015 }
      month { 7 }
    end

    factory :final_month do
      year { 2017 }
      month { 3 }
    end

    factory :before_employment do
      year { 2015 }
      month { 4 }
    end

    factory :after_termination do
      year { 2017 }
      month { 4 }
    end
  end
end
