# frozen_string_literal: true
require "test_helper"

class IrregularIncomeTest < ActiveSupport::TestCase
  def test_income_tax_over_exemption
    employee = build(:employee, start_date: "2018-01-01")
    salary = build(:salary, tax_code: "50", monthly_wage: "50000", insured_for_labor: "45800", effective_date: "2018-01-01", employee: employee)
    payroll = build(:payroll, salary: salary, year: 2018, month: 5, festival_bonus: 50000, employee: employee) do |pr|
      create(:extra_entry, taxable: true, amount: 50000, payroll: pr)
    end
    assert_equal IncomeTaxService::IrregularIncome.call(payroll), 5000
  end

  def test_income_tax_under_exemption
    employee = build(:employee, start_date: "2018-01-01")
    salary = build(:salary, tax_code: "50", monthly_wage: "50000", insured_for_labor: "45800", effective_date: "2018-01-01", employee: employee)
    payroll = build(:payroll, salary: salary, year: 2018, month: 5, employee: employee) do |pr|
      create(:extra_entry, taxable: true, amount: 50000, payroll: pr)
    end
    assert_equal IncomeTaxService::IrregularIncome.call(payroll), 0
  end
end
