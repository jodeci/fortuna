# frozen_string_literal: true
class TaxService
  attr_reader :payroll, :salary

  def initialize(payroll, salary)
    @payroll = payroll
    @salary = salary
  end

  def run
    professional_service_income_tax + irregular_income_tax + parttime_income_tax
  end

  private

  # 執行業務所得超過兩萬元 需代扣 10% 所得稅
  def professional_service_income_tax
    return 0 unless professional_service_income_taxable?
    (income * professional_service_income_tax_rate).round
  end

  # 非經常性給予超過 73500 元 需代扣 5% 所得稅
  def irregular_income_tax
    return 0 unless irregular_income_taxable?
    (irregular_income * salary_income_tax_rate).round
  end

  # 兼職所得超過 73500 元 需代扣 5% 所得稅
  def parttime_income_tax
    return 0 unless parttime_income_taxable?
    (income * salary_income_tax_rate).round
  end

  def professional_service_income_taxable?
    return false unless salary.professional_service?
    income > professional_service_income_tax_threshold
  end

  def irregular_income_taxable?
    irregular_income > irregular_income_tax_threshold
  end

  def parttime_income_taxable?
    return false if salary.insuranced?
    income > irregular_income_tax_threshold
  end

  def income
    IncomeService.new(payroll, salary).total
  end

  def irregular_income
    payroll.taxable_irregular_income
  end

  def professional_service_income_tax_threshold
    20000
  end

  def irregular_income_tax_threshold
    payroll.year >= 2017 ? 73500 : 73000
  end

  def professional_service_income_tax_rate
    0.1
  end

  def salary_income_tax_rate
    0.05
  end
end
