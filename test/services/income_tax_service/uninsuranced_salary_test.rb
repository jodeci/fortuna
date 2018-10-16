# frozen_string_literal: true
require "test_helper"

class UninsurancedSalaryTest < ActiveSupport::TestCase
  def income_tax_over_exemption
    employee = build(:employee, start_date: "2018-01-01")
    salary = build(:salary, tax_code: "50", monthly_wage: "100000", effective_date: "2018-01-01", employee: employee)
    payroll = build(:payroll, salary: salary, year: 2018, month: 5, employee: employee)
    assert_equal IncomeTaxService::UninsuredSalary.call(payroll), 5000
  end

  def income_tax_under_exemption
    employee = build(:employee, start_date: "2018-01-01")
    salary = build(:salary, tax_code: "50", monthly_wage: "20000", effective_date: "2018-01-01", employee: employee)
    payroll = build(:payroll, salary: salary, year: 2018, month: 5, employee: employee)
    assert_equal IncomeTaxService::UninsuredSalary.call(payroll), 0
  end
end
