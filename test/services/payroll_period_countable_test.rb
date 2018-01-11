# frozen_string_literal: true
require "test_helper"

class PayrollPeriodCountableTest < ActiveSupport::TestCase
  def subject(payroll)
    MonthlyBasedIncomeService.new(payroll, nil)
  end

  def test_first_month_true
    employee = build(:employee, start_date: "2015-05-13", end_date: "2017-10-20")
    payroll = build(:payroll, year: 2015, month: 5, employee: employee)
    assert subject(payroll).first_month?
  end

  def test_first_month_false
    employee = build(:employee, start_date: "2015-05-13", end_date: "2017-10-20")
    payroll = build(:payroll, year: 2015, month: 6, employee: employee)
    assert_not subject(payroll).first_month?
  end

  def test_final_month_true
    employee = build(:employee, start_date: "2015-05-13", end_date: "2017-10-20")
    payroll = build(:payroll, year: 2017, month: 10, employee: employee)
    assert subject(payroll).final_month?
  end

  def test_final_month_false
    employee = build(:employee, start_date: "2015-05-13", end_date: "2017-10-20")
    payroll = build(:payroll, year: 2017, month: 2, employee: employee)
    assert_not subject(payroll).final_month?
  end

  def test_payment_period_in_first_month
    employee = build(:employee, start_date: "2015-05-13", end_date: "2017-10-20")
    payroll = build(:payroll, year: 2015, month: 5, employee: employee)
    assert_equal subject(payroll).period_length, 18
  end

  def test_employee_on_payroll_in_normal_month
    employee = build(:employee, start_date: "2015-05-13", end_date: "2017-10-20")
    payroll = build(:payroll, year: 2015, month: 7, employee: employee)
    assert_equal subject(payroll).period_length, 30
  end

  def test_payment_period_in_final_month
    employee = build(:employee, start_date: "2015-05-13", end_date: "2017-10-20")
    payroll = build(:payroll, year: 2017, month: 10, employee: employee)
    assert_equal subject(payroll).period_length, 20
  end

  def test_payment_period_before_employement
    employee = build(:employee, start_date: "2015-05-13", end_date: "2017-10-20")
    payroll = build(:payroll, year: 2015, month: 4, employee: employee)
    assert_equal subject(payroll).period_length, 0
  end

  def test_payment_period_after_termination
    employee = build(:employee, start_date: "2015-05-13", end_date: "2017-10-20")
    payroll = build(:payroll, year: 2017, month: 11, employee: employee)
    assert_equal subject(payroll).period_length, 0
  end

  def test_payment_period_30_days_in_february_ongoing_employee
    employee = build(:employee, start_date: "2015-05-13")
    payroll = build(:payroll, year: 2016, month: 2, employee: employee)
    assert_equal subject(payroll).period_length, 30
  end

  def test_payment_period_30_days_in_large_month_ongoing_employee
    employee = build(:employee, start_date: "2015-05-13")
    payroll = build(:payroll, year: 2016, month: 7, employee: employee)
    assert_equal subject(payroll).period_length, 30
  end

  def test_payment_period_30_days_edge_february
    employee = build(:employee, start_date: "2015-05-13", end_date: "2016-02-29")
    payroll = build(:payroll, year: 2016, month: 2, employee: employee)
    assert_equal subject(payroll).period_length, 30
  end

  def test_payment_period_30_days_edge_large_month
    employee = build(:employee, start_date: "2015-05-13", end_date: "2016-07-31")
    payroll = build(:payroll, year: 2016, month: 7, employee: employee)
    assert_equal subject(payroll).period_length, 30
  end

  def test_payment_period_contractor
    employee = build(:employee, start_date: "2018-02-21", type: "ContractorEmployee", end_date: "2018-02-28")
    payroll = build(:payroll, year: 2018, month: 2, employee: employee)
    assert_equal subject(payroll).period_length, 5
  end
end
