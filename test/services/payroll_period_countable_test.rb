# frozen_string_literal: true
require "test_helper"

class PayrollPeriodCountableTest < ActiveSupport::TestCase
  def regular_employee
    build(:employee, start_date: "2015-05-13", end_date: "2017-10-20")
  end

  def payroll(year:, month:, employee: regular_employee)
    build(:payroll, year: year, month: month, employee: employee)
  end

  def test_first_month_true
    service = MonthlyBasedIncomeService.new(payroll(year: 2015, month: 5), nil)
    assert service.first_month?
  end

  def test_first_month_false
    service = MonthlyBasedIncomeService.new(payroll(year: 2015, month: 6), nil)
    assert_not service.first_month?
  end

  def test_final_month_true
    service = MonthlyBasedIncomeService.new(payroll(year: 2017, month: 10), nil)
    assert service.final_month?
  end

  def test_final_month_false
    service = MonthlyBasedIncomeService.new(payroll(year: 2017, month: 2), nil)
    assert_not service.final_month?
  end

  def test_payment_period_in_first_month
    service = MonthlyBasedIncomeService.new(payroll(year: 2015, month: 5), nil)
    assert_equal service.period_length, 18
  end

  def test_employee_on_payroll_in_normal_month
    service = MonthlyBasedIncomeService.new(payroll(year: 2015, month: 7), nil)
    assert_equal service.period_length, 30
  end

  def test_payment_period_in_final_month
    service = MonthlyBasedIncomeService.new(payroll(year: 2017, month: 10), nil)
    assert_equal service.period_length, 20
  end

  def test_payment_period_before_employement
    service = MonthlyBasedIncomeService.new(payroll(year: 2015, month: 4), nil)
    assert_equal service.period_length, 0
  end

  def test_payment_period_after_termination
    service = MonthlyBasedIncomeService.new(payroll(year: 2017, month: 11), nil)
    assert_equal service.period_length, 0
  end

  def test_payment_period_30_days_in_february_ongoing_regular_employee
    employee = build(:employee, start_date: "2015-05-13")
    service = MonthlyBasedIncomeService.new(payroll(year: 2016, month: 2, employee: employee), nil)
    assert_equal service.period_length, 30
  end

  def test_payment_period_30_days_in_large_month_ongoing_regular_employee
    employee = build(:employee, start_date: "2015-05-13")
    service = MonthlyBasedIncomeService.new(payroll(year: 2016, month: 7, employee: employee), nil)
    assert_equal service.period_length, 30
  end

  def test_payment_period_30_days_edge_february
    employee = build(:employee, start_date: "2015-05-13", end_date: "2016-02-29")
    service = MonthlyBasedIncomeService.new(payroll(year: 2016, month: 2, employee: employee), nil)
    assert_equal service.period_length, 30
  end

  def test_payment_period_30_days_edge_large_month
    employee = build(:employee, start_date: "2015-05-13", end_date: "2016-07-31")
    service = MonthlyBasedIncomeService.new(payroll(year: 2016, month: 7, employee: employee), nil)
    assert_equal service.period_length, 30
  end
end
