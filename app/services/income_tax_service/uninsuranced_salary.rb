# frozen_string_literal: true
module IncomeTaxService
  class UninsurancedSalary
    include Callable
    include Calculatable

    attr_reader :payroll

    def initialize(payroll)
      @payroll = payroll
    end

    # 兼職所得超過免稅額 需代扣 5% 所得稅
    def call
      return 0 unless taxable?
      (taxable_income * rate).round
    end

    private

    def taxable?
      taxable_income > exemption
    end

    def exemption
      IncomeTaxService::Exemption.call(payroll.year, payroll.month)
    end

    def rate
      0.05
    end
  end
end
