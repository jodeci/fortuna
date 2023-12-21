# frozen_string_literal: true
# 二代健保：執行業務所得 單次給付超過兩萬元
module HealthInsuranceService
  class ProfessionalService
    include Callable
    include Calculatable

    attr_reader :payroll

    def initialize(payroll)
      @payroll = payroll
    end

    def call
      return 0 if payroll.salary.split?
      return 0 unless eligible?
      premium
    end

    private

    def premium
      (premium_base * rate).ceil
    end

    def rate
      HealthInsuranceService::SupplementPremiumRate.call(payroll.year, payroll.month)
    end

    def eligible?
      taxable_income > exemption
    end

    def premium_base
      taxable_income
    end

    def exemption
      20000
    end
  end
end
