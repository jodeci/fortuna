# frozen_string_literal: true
class LaborInsuranceService
  include PayrollPeriodCountable

  attr_reader :payroll, :salary

  def initialize(payroll, salary)
    @payroll = payroll
    @salary = salary
  end

  # TODO: 勞保費計算
  def run
    adjust_for_incomplete_month_by_30_days(salary.labor_insurance).round
  end
end
