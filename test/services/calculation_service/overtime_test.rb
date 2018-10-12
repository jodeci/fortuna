# frozen_string_literal: true
require "test_helper"

class OvertimeTest < ActiveSupport::TestCase
  def salary
    build(:salary, monthly_wage: 36000)
  end

  def payroll
    build(:payroll, salary: salary)
  end

  def test_weekday_initial_rate
    overtime = build(:overtime, payroll: payroll, hours: 1, rate: :weekday)
    assert_equal CalculationService::Overtime.call(overtime), 200
  end

  def test_weekday_additional_rate
    overtime = build(:overtime, payroll: payroll, hours: 3, rate: :weekday)
    assert_equal CalculationService::Overtime.call(overtime), (200 * 2 + 250)
  end

  def test_weekend_initial_rate
    overtime = build(:overtime, payroll: payroll, hours: 1, rate: :weekend)
    assert_equal CalculationService::Overtime.call(overtime), 200
  end

  def test_weekend_additional_rate
    overtime = build(:overtime, payroll: payroll, hours: 3, rate: :weekend)
    assert_equal CalculationService::Overtime.call(overtime), (200 * 2 + 250)
  end

  def test_weekend_final_rate
    overtime = build(:overtime, payroll: payroll, hours: 10, rate: :weekend)
    assert_equal CalculationService::Overtime.call(overtime), (200 * 2 + 250 * 6 + 400 * 2)
  end

  def test_holiday_rate
    overtime = build(:overtime, payroll: payroll, hours: 1, rate: :holiday)
    assert_equal CalculationService::Overtime.call(overtime), (150 * 8 * 2)
  end
end
