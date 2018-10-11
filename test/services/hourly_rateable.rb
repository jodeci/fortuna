# frozen_string_literal: true
require "test_helper"

class HourlyRateableTest < ActiveSupport::TestCase
  def subject(salary)
    LeavetimeService.new(0, salary, 30)
  end

  def test_hourly_rate_for_fulltime_employee
    salary = build(:salary, monthly_wage: 36000, monthly_wage_adjustment: 1.0)
    assert_equal subject(salary).hourly_rate, 150
  end

  def test_hourly_rate_for_parttime_employee
    salary = build(:salary, monthly_wage: 24000, equipment_subisdy: 800, monthly_wage_adjustment: 0.6)
    assert_equal subject(salary).hourly_rate, 170
  end
end
