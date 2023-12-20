# frozen_string_literal: true
# 二代健保：兼職薪資所得 單次給付超過最低薪資
module HealthInsuranceService
  class ParttimeIncome
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
      MinimumWageService.call(payroll.year, payroll.month)
    end
  end
end
