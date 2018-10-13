# frozen_string_literal: true
module CalculationService
  class IncomeTax
    include Callable

    attr_reader :payroll, :salary

    def initialize(payroll)
      @payroll = payroll
      @salary = payroll.salary
    end

    def call
      professional_service_income_tax + parttime_income_tax + irregular_income_tax
    end

    private

    # 執行業務所得超過兩萬元 需代扣 10% 所得稅
    def professional_service_income_tax
      return 0 unless professional_service_income_taxable?
      (income * professional_service_income_tax_rate).round
    end

    # 兼職所得超過 73500 元 需代扣 5% 所得稅
    def parttime_income_tax
      return 0 unless parttime_income_taxable?
      (income * salary_income_tax_rate).round
    end

    # 非經常性給予超過 73500 元 需代扣 5% 所得稅
    def irregular_income_tax
      return 0 unless irregular_income_taxable?
      (irregular_income * salary_income_tax_rate).round
    end

    def professional_service_income_taxable?
      return false unless salary.professional_service?
      income > professional_service_income_tax_threshold
    end

    def parttime_income_taxable?
      return false unless salary.parttime_income?
      income > irregular_income_tax_threshold
    end

    def irregular_income_taxable?
      return false unless salary.regular_income?
      irregular_income > irregular_income_tax_threshold
    end

    def income
      CalculationService::TotalIncome.call(payroll)
    end

    def irregular_income
      payroll.taxable_irregular_income
    end

    def professional_service_income_tax_threshold
      20000
    end

    # 薪資所得扣繳稅額表無配偶及受扶養親屬者之起扣標準（也太長）
    def irregular_income_tax_threshold
      date = Date.new(payroll.year, payroll.month, 1)
      if date >= Date.new(2018, 1, 1)
        84500
      elsif date >= Date.new(2017, 1, 1)
        73500
      else
        73000 # 再往下寫沒意義
      end
    end

    def professional_service_income_tax_rate
      0.1
    end

    def salary_income_tax_rate
      0.05
    end
  end
end
