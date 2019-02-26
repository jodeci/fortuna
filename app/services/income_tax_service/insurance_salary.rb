# frozen_string_literal: true
module IncomeTaxService
  class InsuranceSalary
    include Callable
    include Calculatable

    attr_reader :payroll, :call_type

    def initialize(payroll, call_type)
      @payroll = payroll
      @call_type = call_type
    end

    # 非經常性給予超過免稅額 需代扣 5% 所得稅
    def call
      case call_type
      when "salary"
        insurance_tax
      when "both"
        insurance_tax + (irregular_income * rate).round
      end
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
