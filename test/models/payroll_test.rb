# frozen_string_literal: true
require "test_helper"

class PayrollTest < ActiveSupport::TestCase
  def test_find_salary_before_onboard
    employee = build(:employee, start_date: "2015-05-13")
    payroll = build(:payroll, year: 2015, month: 4, employee: employee)
    assert_nil payroll.find_salary
  end

  def test_find_salary_after_termination
    employee = build(:employee, end_date: "2015-05-13")
    payroll = build(:payroll, year: 2015, month: 6, employee: employee)
    assert_nil payroll.find_salary
  end

  def employee_with_salaries
    build(:employee, start_date: "2015-05-13") do |employee|
      create(:salary, base: 36000, start_date: "2015-05-13", employee: employee)
      create(:salary, base: 40000, start_date: "2015-09-01", employee: employee)
    end
  end

  def test_find_salary_1
    payroll = build(:payroll, year: 2015, month: 5, employee: employee_with_salaries)
    assert_equal payroll.find_salary.base, 36000
  end

  def test_find_salary_2
    payroll = build(:payroll, year: 2015, month: 9, employee: employee_with_salaries)
    assert_equal payroll.find_salary.base, 40000
  end

  def test_days_in_month_for_regular_employee
    employee = build(:employee, start_date: "2017-02-21", type: "regular")
    payroll = build(:payroll, year: 2015, month: 2, employee: employee)
    assert_equal payroll.days_in_month, 30
  end

  def test_days_in_month_for_contractor
    skip "to be implemented"
    employee = build(:employee, start_date: "2017-02-21", type: "contractor")
    payroll = build(:payroll, year: 2017, month: 2, employee: employee)
    assert_equal payroll.days_in_month, 15
  end
end
