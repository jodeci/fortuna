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
      (premium_base * rate).ceil
    end

    private

    def premium_base
      owner_income + excess_payments
    end

    # 負責人薪資全額
    # FIXME: 負責人有變動的可能
    def owner_income
      row = PayrollDetail.owner_income(year: year, month: month)
      row.amount - row.subsidy_income
    end

    # （負責人以外）實發薪資與投保薪資的差額
    def excess_payments
      PayrollDetail.monthly_excess_payment(year: year, month: month).sum(:excess_income)
    end

    def rate
      HealthInsuranceService::SupplementPremiumRate.call(year, month)
    end
  end
end
