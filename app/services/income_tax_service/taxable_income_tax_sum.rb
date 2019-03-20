# frozen_string_literal: true
module IncomeTaxService
  class TaxableIncomeTaxSum
    include Callable

    attr_reader :year, :month

    def initialize(year, month)
      @year = year.to_i
      @month = month.to_i
    end

    def call
      sum = 0
      Payroll.where(year: year, month: month).map do |payroll|
        if payroll.salary.regular_income? or payroll.salary.insured_for_labor_and_uninsured_for_health?
          tax = IncomeTaxService::InsurancedSalary.call(payroll)
          sum += tax if tax.positive?
        end
      end
      sum
    end
  end
end
