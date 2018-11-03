# frozen_string_literal: true
require "test_helper"

module CalculationService
  class VacationRefundTest < ActiveSupport::TestCase
    def test_refund_with_fulltime_salary
      salary = build(:salary, monthly_wage: 36000)
      payroll = build(:payroll, salary: salary, vacation_refund_hours: 1)
      assert_equal 150, CalculationService::VacationRefund.call(payroll)
    end

    def test_refund_with_parttime_salary
      salary = build(:salary, monthly_wage: 24000, equipment_subsidy: 800, monthly_wage_adjustment: 0.6)
      payroll = build(:payroll, salary: salary, vacation_refund_hours: 1)
      assert_equal 170, CalculationService::VacationRefund.call(payroll)
    end
  end
end
