# frozen_string_literal: true
class HealthInsuranceService
  attr_reader :payroll, :salary

  # 法規上，正職的健保必須保在公司
  # 實務上，健保在公司的人一定會有勞保
  # 健保計算是整月，不足月不做調整

  def initialize(payroll, salary)
    @payroll = payroll
    @salary = salary
  end

  # TODO: 健保費計算（含家眷）
  def normal
    salary.health_insurance
  end

  # 二代健保
  #   執行業務所得 單次給付超過兩萬元
  #   兼職薪資所得 單次給付超過最低薪資
  def supplement_premium
    return 0 unless eligible_for_nhi2g?
    (income * supplement_premium_rate).round
  end

  private

  def eligible_for_nhi2g?
    return false if salary.regular?
    service_income_eligible? or parttime_income_eligible?
  end

  # TODO: 全年累計超過當月投保金額4倍部分的獎金
  # def bonus_eligible_for_nhi2g?
  # end

  def service_income_eligible?
    income > service_income_threshold if salary.professional_service?
  end

  def parttime_income_eligible?
    income > minimum_wage if salary.parttime?
  end

  def income
    IncomeService.new(payroll, salary).total
  end

  def supplement_premium_rate
    0.0191
  end

  def service_income_threshold
    20000
  end

  def minimum_wage
    date = Date.new(payroll.year, payroll.month, 1)
    if date >= Date.new(2018, 1, 1)
      22000
    elsif date >= Date.new(2017, 1, 1)
      21009
    elsif date >= Date.new(2016, 10, 1)
      20008
    elsif date >= Date.new(2014, 7, 1)
      19273
    elsif date >= Date.new(2014, 1, 1)
      19047
    else
      18780 # 再往下寫沒意義
    end
  end
end
