# frozen_string_literal: true
# 二代健保：公司代扣總額
module HealthInsuranceService
  class CompanyWithhold
    include Callable

    attr_reader :year, :month, :code

    def initialize(year, month, code)
      @year = year
      @month = month
      @code = code
    end

    # TODO: 拆成兩個物件
    def call
      send("premium_for_#{code}")
    end

    private

    def premium_for_62
      PayrollDetail.monthly_excess_payment(year: year, month: month).reduce(0) do |sum, row|
        sum + HealthInsuranceService::BonusIncome.call(Payroll.find(row.payroll_id))
      end
    end

    def premium_for_65
      sum = 0
      Payroll.where(year: year, month: month).map do |payroll|
        next unless process_65?(payroll)
        sum += HealthInsuranceService::ProfessionalService.call(payroll)
      end
      sum
    end

    def process_65?(payroll)
      payroll.salary.professional_service? && !payroll.salary.split?
    end
  end
end
