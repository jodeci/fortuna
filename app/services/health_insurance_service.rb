# frozen_string_literal: true
class HealthInsuranceService
  include IncomeTaxable

  attr_reader :payroll, :salary

  # 法規上，正職的健保必須保在公司
  # 實務上，健保在公司的人一定會有勞保
  # 健保計算是整月，不足月不做調整

  def initialize(payroll, salary)
    @payroll = payroll
    @salary = salary
  end

  # TODO: 健保費計算（含家眷）
  # DB 應該存投保薪資+家眷人數?
  def normal
    salary.health_insurance
  end

  # 二代健保 執行業務所得 單次給付超過20000元
  # 二代健保 兼職薪資所得 單次給付超過最低薪資
  def second_generation
    return 0 unless income_9A?
    (income * rate).round
  end

  # TODO: 二代健保 全年獎金超過投保金額四倍，超過的部分，只在年底計算
  # 需存投保金額？

  private

  def rate
    0.0191
  end
end
