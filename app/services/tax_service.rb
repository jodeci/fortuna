# frozen_string_literal: true
class TaxService
  attr_reader :payroll, :salary

  def initialize(payroll, salary)
    @payroll = payroll
    @salary = salary
  end

  # TODO: 百廢待舉
  def run
    professional_service_income
  end

  # 執行業務所得超過兩萬元 需代扣 10% 所得稅
  def professional_service_income
    return 0 unless professional_service_income_taxable?
    (income * rate_9a).round
  end

  # 非經常性給予、兼職所得超過 73000 元 需代扣 5% 所得稅

  private

  def professional_service_income_taxable?
    salary.professional_service? and income > threshold_9a
  end

  def income
    IncomeService.new(payroll, salary).total
  end

  def threshold_9a
    20000
  end

  def rate_9a
    0.1
  end
end
