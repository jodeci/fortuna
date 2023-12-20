# frozen_string_literal: true
module IncomeTaxService
  class IrregularIncome
    include Callable
    include Calculatable

    attr_reader :payroll

    def initialize(payroll)
      @payroll = payroll
    end

    # 非經常性給予超過免稅額 需代扣 5% 所得稅
    def call
      return 0 unless taxable?
      (irregular_income * rate).ceil
    end

    private

    def taxable?
      irregular_income > exemption
    end

    def irregular_income
      bonus_income + payroll.extra_income_of(:salary)
    end

    def exemption
      IncomeTaxService::Exemption.call(payroll.year, payroll.month)
    end

    def rate
      0.05
    end
  end
end
