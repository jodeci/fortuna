# frozen_string_literal: true
require "test_helper"

module CalculationService
  class SicktimeTest < ActiveSupport::TestCase
    def test_sicktime_with_fulltime_salary
      salary = build(:salary, monthly_wage: 36000)
      payroll = build(:payroll, salary: salary, sicktime_hours: 1)
      assert_equal 75, CalculationService::Sicktime.call(payroll)
    end

    def test_sicktime_with_parttime_salary
      salary = build(:salary, monthly_wage: 24000, equipment_subsidy: 800, monthly_wage_adjustment: 0.6)
      payroll = build(:payroll, salary: salary, sicktime_hours: 1)
      assert_equal 85, CalculationService::Sicktime.call(payroll)
    end
  end
end
