# frozen_string_literal: true
require "test_helper"

class WorkingDaysTest < ActiveSupport::TestCase
  def regular
    build(:employee, start_date: "2015-05-13", end_date: "2017-10-20")
  end

  def test_employee_on_payroll_in_initial_month
    obj = WorkingDaysService.new build(:payroll, year: 2015, month: 5, employee: regular)
    assert obj.on_payroll?
  end

  def test_payment_period_in_first_month
    obj = WorkingDaysService.new build(:payroll, year: 2015, month: 5, employee: regular)
    assert_equal obj.run, 18
  end

  def test_employee_on_payroll_in_normal_month
    obj = WorkingDaysService.new build(:payroll, year: 2015, month: 7, employee: regular)
    assert obj.on_payroll?
  end

  def test_payment_period_in_normal_month
    obj = WorkingDaysService.new build(:payroll, year: 2015, month: 7, employee: regular)
    assert_equal obj.run, 30
  end

  def test_employee_on_payroll_in_final_month
    obj = WorkingDaysService.new build(:payroll, year: 2017, month: 10, employee: regular)
    assert obj.on_payroll?
  end

  def test_payment_period_in_final_month
    obj = WorkingDaysService.new build(:payroll, year: 2017, month: 10, employee: regular)
    assert_equal obj.run, 20
  end

  def test_employee_not_on_payroll_before_employment
    obj = WorkingDaysService.new build(:payroll, year: 2015, month: 3, employee: regular)
    assert_not obj.on_payroll?
  end

  def test_payment_period_before_employement
    obj = WorkingDaysService.new build(:payroll, year: 2015, month: 3, employee: regular)
    assert_equal obj.run, 0
  end

  def test_employee_not_on_payroll_after_termination
    obj = WorkingDaysService.new build(:payroll, year: 2017, month: 11, employee: regular)
    assert_not obj.on_payroll?
  end

  def test_payment_period_after_termination
    obj = WorkingDaysService.new build(:payroll, year: 2017, month: 11, employee: regular)
    assert_equal obj.run, 0
  end

  def test_payment_period_30_days_in_february_ongoing_employee
    employee = build(:employee, start_date: "2015-05-13")
    obj = WorkingDaysService.new build(:payroll, year: 2016, month: 2, employee: employee)
    assert_equal obj.run, 30
  end

  def test_payment_period_30_days_in_large_month_ongoing_employee
    employee = build(:employee, start_date: "2015-05-13")
    obj = WorkingDaysService.new build(:payroll, year: 2016, month: 3, employee: employee)
    assert_equal obj.run, 30
  end

  def test_payment_period_30_days_edge_february
    employee = build(:employee, start_date: "2015-05-13", end_date: "2016-02-29")
    obj = WorkingDaysService.new build(:payroll, year: 2016, month: 2, employee: employee)
    assert_equal obj.run, 30
  end

  def test_payment_period_30_days_edge_large_month
    employee = build(:employee, start_date: "2015-05-13", end_date: "2016-07-31")
    obj = WorkingDaysService.new build(:payroll, year: 2016, month: 7, employee: employee)
    assert_equal obj.run, 30
  end
end
