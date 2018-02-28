# frozen_string_literal: true

require "taiwanese_id_validator/twid_generator"

FactoryBot.define do
  factory :employee do
    name do
      Faker::Name.name
    end
    company_email do
      Faker::Internet.email
    end
    personal_email do
      Faker::Internet.email
    end
    id_number do
      TwidGenerator.generate
    end
    start_date do
      Date.today - rand(365..1825)
    end

    transient do
      month_salary 50000
      hour_salary 200
      build_statement_immediatedly false
      role "regular"
    end

    factory :resigned_regular_employee do
      end_date do |s|
        s.start_date + 365
      end
    end

    factory :employee_with_payrolls do
      after :create do |emp, ev|
        create :salary, employee: emp, monthly_wage: ev.month_salary, effective_date: emp.start_date, role: ev.role
        TimeDifference.between(emp.start_date, emp.calculate_until).in_months.round.times do |i|
          d = emp.start_date.months_since(i)
          create :payroll, year: d.year, month: d.month, employee: emp, build_statement_immediatedly: ev.build_statement_immediatedly
        end
      end
    end

    factory :parttime_employee_with_payrolls do
      start_date do
        Date.today - rand(90..365)
      end

      transient do
        parttime_hours [50, 100, 150]
      end

      after :create do |emp, ev|
        create :salary, employee: emp, hourly_wage: ev.hour_salary, effective_date: emp.start_date, role: "parttime"
        TimeDifference.between(emp.start_date, emp.calculate_until).in_months.round.times do |i|
          d = emp.start_date.months_since(i)
          create :payroll, year: d.year, month: d.month, employee: emp, parttime_hours: ev.parttime_hours.to_a.sample
        end
      end
    end
  end
end
