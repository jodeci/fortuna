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
      Payroll.where(year: year, month: month).inject(0) do |sum, payroll|
        sum += SalaryService::TaxableIncome.call(payroll)
        sum
      end
    end
  end
end
