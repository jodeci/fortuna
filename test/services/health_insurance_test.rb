# frozen_string_literal: true
require "test_helper"

class HealthInsuranceTest < ActiveSupport::TestCase
  def test_supplement_premium_for_insured_salary
    employee = build(:employee)
    salary = create(:salary, monthly_wage: 36000, tax_code: 50, insured_for_labor: 36300, role: "contractor", employee: employee)
    payroll = create(:payroll, year: 2018, month: 3, employee: employee)
    assert_equal HealthInsuranceService.new(payroll, salary).supplement_premium, 0
  end

  def test_supplement_premium_for_uninsured_salary
    employee = build(:employee)
    salary = create(:salary, monthly_wage: 36000, tax_code: 50, insured_for_labor: 0, role: "contractor", employee: employee)
    payroll = create(:payroll, year: 2018, month: 3, employee: employee)
    assert_equal HealthInsuranceService.new(payroll, salary).supplement_premium, 688
  end

  def test_supplement_premium_for_uninsured_salary_below_threshold
    employee = build(:employee)
    salary = create(:salary, monthly_wage: 22000, tax_code: 50, insured_for_labor: 0, role: "contractor", employee: employee)
    payroll = create(:payroll, year: 2018, month: 3, employee: employee)
    assert_equal HealthInsuranceService.new(payroll, salary).supplement_premium, 0
  end

  def test_supplement_premium_for_professional_service
    employee = build(:employee)
    salary = create(:salary, monthly_wage: 36000, tax_code: "9a", insured_for_labor: 0, role: "contractor", employee: employee)
    payroll = create(:payroll, year: 2018, month: 3, employee: employee)
    assert_equal HealthInsuranceService.new(payroll, salary).supplement_premium, 688
  end

  def test_supplement_premium_for_professional_service_below_threshold
    employee = build(:employee)
    salary = create(:salary, monthly_wage: 20000, tax_code: "9a", insured_for_labor: 0, role: "contractor", employee: employee)
    payroll = create(:payroll, year: 2018, month: 3, employee: employee)
    assert_equal HealthInsuranceService.new(payroll, salary).supplement_premium, 0
  end
end
