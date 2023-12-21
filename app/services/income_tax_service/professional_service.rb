# frozen_string_literal: true
module IncomeTaxService
  class ProfessionalService
    include Callable
    include Calculatable

    attr_reader :payroll

    def initialize(payroll)
      @payroll = payroll
    end

    # 執行業務所得超過兩萬元 需代扣 10% 所得稅
    def call
      return 0 if payroll.salary.split?
      return 0 unless taxable?
      (taxable_income * rate).ceil
    end

    private

    def taxable?
      taxable_income > exemption
    end

    def exemption
      20000
    end

    def rate
      0.1
    end
  end
end
