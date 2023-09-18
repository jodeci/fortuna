# frozen_string_literal: true
module HealthInsuranceService
  class CompanyCoverage
    include Callable

    attr_reader :year, :month

    def initialize(year, month)
      @year = year.to_i
      @month = month.to_i
    end

    def call
      (premium_base * rate).round
    end

    private

    def premium_base
      excess_payments
    end

    # 實發薪資與投保薪資的差額
    def excess_payments
      PayrollDetail.monthly_excess_payment(year: year, month: month).sum(:excess_income)
    end

    def rate
      HealthInsuranceService::SupplementPremiumRate.call(year, month)
    end
  end
end
