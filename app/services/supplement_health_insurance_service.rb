# frozen_string_literal: true
class SupplementHealthInsuranceService
  include Callable
  include Calculatable

  attr_reader :payroll, :salary

  # 法規上，正職的健保必須保在公司
  # 實務上，健保在公司的人一定會有勞保
  # 健保計算是整月，不足月不做調整

  def initialize(payroll)
    @payroll = payroll
    @salary = payroll.salary
  end

  # 二代健保
  #   執行業務所得 單次給付超過兩萬元
  #   兼職薪資所得 單次給付超過最低薪資
  def call
    return 0 unless eligible_for_nhi2g?
    (income * supplement_premium_rate).round
  end

  private

  def eligible_for_nhi2g?
    return false if salary.regular_income?
    service_income_eligible? or parttime_income_eligible?
  end

  # TODO: 全年累計超過當月投保金額4倍部分的獎金
  # def bonus_eligible_for_nhi2g?
  # end

  def service_income_eligible?
    income > service_income_threshold if salary.professional_service?
  end

  def parttime_income_eligible?
    income > minimum_wage if salary.parttime_income?
  end

  def income
    CalculationService::TotalIncome.call(payroll) - withholdings
  end

  def supplement_premium_rate
    0.0191
  end

  def service_income_threshold
    20000
  end

  def minimum_wage
    MinimumWageService.call(payroll.year, payroll.month)
  end
end
