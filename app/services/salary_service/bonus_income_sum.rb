# frozen_string_literal: true
module SalaryService
  class BonusIncomeSum
    include Callable

    attr_reader :year, :month

    def initialize(year, month)
      @year = year.to_i
      @month = month.to_i
    end

    def call
      sum = 0
      Payroll.where(year: year, month: month).map do |payroll|
        sum += SalaryService::BonusIncome.call(payroll)
      end
      sum
    end
  end
end
