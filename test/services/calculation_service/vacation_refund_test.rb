# frozen_string_literal: true
require "test_helper"

class VacationRefundTest < ActiveSupport::TestCase
  def test_refund_with_fulltime_salary
    salary = build(:salary, monthly_wage: 36000)
    payroll = build(:payroll, salary: salary, vacation_refund_hours: 1)
    assert_equal CalculationService::VacationRefund.call(payroll), 150
  end

  def test_refund_with_parttime_salary
    salary = build(:salary, monthly_wage: 24000, equipment_subsidy: 800, monthly_wage_adjustment: 0.6)
    payroll = build(:payroll, salary: salary, vacation_refund_hours: 1)
    assert_equal CalculationService::VacationRefund.call(payroll), 170
  end
end
