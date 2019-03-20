# frozen_string_literal: true
module CalculationService
  class TotalEmployee
    include Callable

    attr_reader :year, :month

    def initialize(year, month)
      @year = year.to_i
      @month = month.to_i
    end

    def call
      num = 0
      Payroll.where(year: year, month: month).map do |payroll|
        tax = IncomeTaxService::InsurancedSalary.call(payroll)
        if tax.positive?
          num += 1 if payroll.salary.regular_income? or payroll.salary.insured_for_labor_and_uninsured_for_health?
        end
      end
      num
    end
  end
end
