# frozen_string_literal: true
class HealthInsuranceService
  include PayrollPeriodCountable

  attr_reader :payroll, :salary, :employee

  def initialize(payroll, salary)
    @payroll = payroll
    @employee = payroll.employee
    @salary = salary
  end

  # TODO: 健保費計算（含家眷）
  def normal
    adjust_for_incomplete_month_by_30_days(salary.health_insurance).round
  end

  # 二代健保 勞保不在公司，勞務費超過最低薪資
  def second_generation
    return 0 if salary.labor_insurance?
    return 0 if salary.base < minimum_wage
    (income * rate).round
  end

  # TODO: 二代健保 全年獎金超過投保金額四倍，超過的部分，只在年底計算
  # 需存投保金額？

  private

  def rate
    0.0191
  end

  def minimum_wage
    22000
  end

  def income
    IncomeService.new(payroll, salary).run.values.reduce(:+)
  end
end
