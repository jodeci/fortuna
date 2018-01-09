# frozen_string_literal: true
require "test_helper"

class PayrollTest < ActiveSupport::TestCase
  def employee
    # 2015-05: 36000, 2015-09: 40000
    create(:regular_employee, end_date: "2016-07-13")
  end

  def test_find_salary_before_onboard
    payroll = build(:payroll, year: 2015, month: 4, employee: employee)
    assert_nil payroll.find_salary
  end

  def test_find_salary_after_termination
    payroll = build(:payroll, year: 2016, month: 8, employee: employee)
    assert_nil payroll.find_salary
  end

  def test_find_salary_1
    payroll = build(:payroll, year: 2015, month: 5, employee: employee)
    assert_equal payroll.find_salary.base, 36000
  end

  def test_find_salary_2
    payroll = build(:payroll, year: 2015, month: 10, employee: employee)
    assert_equal payroll.find_salary.base, 40000
  end
end
