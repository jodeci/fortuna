# frozen_string_literal: true
# 二代健保：公司代扣總額（獎金）
module HealthInsuranceService
  class CompanyWithholdBonus
    include Callable

    attr_reader :year, :month

    def initialize(year, month)
      @year = year
      @month = month
    end

    def call
      premium
    end

    private

    def premium
      PayrollDetail.monthly_excess_payment(year: year, month: month).reduce(0) do |sum, row|
        sum + HealthInsuranceService::BonusIncome.call(Payroll.find(row.payroll_id))
      end
    end
  end
end
