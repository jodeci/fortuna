# frozen_string_literal: true
require "test_helper"

class IncomeTaxTest < ActiveSupport::TestCase
  def test_professional_service_income_tax
    employee = build(:employee, start_date: "2018-01-01")
    salary = build(:salary, tax_code: "9a", monthly_wage: "100000", effective_date: "2018-01-01", employee: employee)
    payroll = build(:payroll, salary: salary, year: 2018, month: 5, employee: employee)
    assert_equal CalculationService::IncomeTax.call(payroll), 10000
  end

  def test_professional_service_income_tax_under_thershold
    employee = build(:employee, start_date: "2018-01-01")
    salary = build(:salary, tax_code: "9a", monthly_wage: "20000", effective_date: "2018-01-01", employee: employee)
    payroll = build(:payroll, salary: salary, year: 2018, month: 5, employee: employee)
    assert_equal CalculationService::IncomeTax.call(payroll), 0
  end

  def test_parttime_income_tax
    employee = build(:employee, start_date: "2018-01-01")
    salary = build(:salary, tax_code: "50", monthly_wage: "100000", effective_date: "2018-01-01", employee: employee)
    payroll = build(:payroll, salary: salary, year: 2018, month: 5, employee: employee)
    assert_equal CalculationService::IncomeTax.call(payroll), 5000
  end

  def test_parttime_income_tax_under_threshold
    employee = build(:employee, start_date: "2018-01-01")
    salary = build(:salary, tax_code: "50", monthly_wage: "20000", effective_date: "2018-01-01", employee: employee)
    payroll = build(:payroll, salary: salary, year: 2018, month: 5, employee: employee)
    assert_equal CalculationService::IncomeTax.call(payroll), 0
  end

  def test_irregular_income_tax
    employee = build(:employee, start_date: "2018-01-01")
    salary = build(:salary, tax_code: "50", monthly_wage: "50000", insured_for_labor: "45800", effective_date: "2018-01-01", employee: employee)
    payroll = build(:payroll, salary: salary, year: 2018, month: 5, festival_bonus: 50000, employee: employee) do |pr|
      create(:extra_entry, taxable: true, amount: 50000, payroll: pr)
    end
    assert_equal CalculationService::IncomeTax.call(payroll), 5000
  end

  def test_irregular_income_tax_underthreshold
    employee = build(:employee, start_date: "2018-01-01")
    salary = build(:salary, tax_code: "50", monthly_wage: "50000", insured_for_labor: "45800", effective_date: "2018-01-01", employee: employee)
    payroll = build(:payroll, salary: salary, year: 2018, month: 5, employee: employee) do |pr|
      create(:extra_entry, taxable: true, amount: 50000, payroll: pr)
    end
    assert_equal CalculationService::IncomeTax.call(payroll), 0
  end
end
