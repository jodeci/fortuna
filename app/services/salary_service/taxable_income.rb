# frozen_string_literal: true
module SalaryService
  class TaxableIncome
    include Callable
    include Calculatable

    attr_reader :payroll

    def initialize(payroll)
      @payroll = payroll
    end

    def call
      taxable_income
    end
  end
end
