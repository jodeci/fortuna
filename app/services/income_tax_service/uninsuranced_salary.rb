# frozen_string_literal: true
module IncomeTaxService
  class UninsurancedSalary
    include Callable
    include Calculatable

    attr_reader :payroll

    def initialize(payroll)
      @payroll = payroll
    end

    # 151 繳款書是同一欄所以合併處理
    def call
      return 0 if payroll.salary.split?
      salary_tax + bonus_tax
    end

    private

    # 兼職所得超過免稅額 需代扣 5% 所得稅
    def salary_tax
      return 0 unless taxable_income > exemption
      (taxable_income * rate).ceil
    end

    # 獎金所得超過免稅額 需代扣 5% 所得稅
    def bonus_tax
      return 0 unless bonus_income > exemption
      (bonus_income * rate).ceil
    end

    def exemption
      IncomeTaxService::Exemption.call(payroll.year, payroll.month)
    end

    def rate
      0.05
    end
  end
end
