# frozen_string_literal: true
module SalaryService
  class TaxableIncomeSum
    include Callable

    attr_reader :year, :month

    def initialize(year, month)
      @year = year.to_i
      @month = month.to_i
    end

    def call
      sum = 0
      Payroll.where(year: year, month: month).map do |payroll|
        tax = IncomeTaxService::InsurancedSalary.call(payroll)
        if tax.positive?
          sum += SalaryService::TaxableIncome.call(payroll) if payroll.salary.regular_income? or payroll.salary.insured_for_labor_and_uninsured_for_health?
        end
      end
      sum
    end
  end
end
