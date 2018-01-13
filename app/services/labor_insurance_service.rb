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
    scale_for_30_days(salary.labor_insurance).round
  end
end
