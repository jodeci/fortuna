# frozen_string_literal: true
require "test_helper"

class WorkingDaysTest < ActiveSupport::TestCase
  def test_employee_on_payroll_in_initial_month
    payroll = build(:initial_month)
    obj = WorkingDaysService.new(payroll)
    assert obj.on_payroll?
  end

  def test_employee_on_payroll_in_normal_month
    payroll = build(:normal_month)
    obj = WorkingDaysService.new(payroll)
    assert obj.on_payroll?
  end

  def test_employee_on_payroll_in_final_month
    payroll = build(:final_month)
    obj = WorkingDaysService.new(payroll)
    assert obj.on_payroll?
  end

  def test_employee_not_on_payroll_before_employment
    payroll = build(:before_employment)
    obj = WorkingDaysService.new(payroll)
    assert_not obj.on_payroll?
  end

  def test_employee_not_on_payroll_after_termination
    payroll = build(:after_termination)
    obj = WorkingDaysService.new(payroll)
    assert_not obj.on_payroll?
  end

  def test_payment_period_in_first_month
    payroll = build(:initial_month)
    obj = WorkingDaysService.new(payroll)
    assert_equal obj.run, 18
  end

  def test_payment_period_in_normal_month
    payroll = build(:normal_month)
    obj = WorkingDaysService.new(payroll)
    assert_equal obj.run, 30
  end

  def test_payment_period_in_final_month
    payroll = build(:final_month)
    obj = WorkingDaysService.new(payroll)
    assert_equal obj.run, 17
  end

  def test_payment_period_before_employement
    payroll = build(:before_employment)
    obj = WorkingDaysService.new(payroll)
    assert_equal obj.run, 0
  end

  def test_payment_period_after_termination
    payroll = build(:after_termination)
    obj = WorkingDaysService.new(payroll)
    assert_equal obj.run, 0
  end

  def test_payment_period_30_days_in_february
    employee = build(:fulltime_employee, end_date: nil)
    payroll = build(:fulltime_payroll, year: 2016, month: 2, employee: employee)
    obj = WorkingDaysService.new(payroll)
    assert_equal obj.run, 30
  end

  def test_payment_period_30_days_in_big_month
    employee = build(:fulltime_employee, end_date: nil)
    payroll = build(:fulltime_payroll, year: 2016, month: 3, employee: employee)
    obj = WorkingDaysService.new(payroll)
    assert_equal obj.run, 30
  end
end
