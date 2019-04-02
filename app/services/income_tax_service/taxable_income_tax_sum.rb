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
      Payroll.where(year: year, month: month).inject(0) do |sum, payroll|
        tax = IncomeTaxService::InsurancedSalary.call(payroll)
        sum += tax if payroll.salary.regular_income? or payroll.salary.insured_for_labor_and_uninsured_for_health?
        sum
      end
    end
  end
end
