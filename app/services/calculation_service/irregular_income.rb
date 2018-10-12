# frozen_string_literal: true
module CalculationService
  class IrregularIncome
    include Callable
    include Calculatable

    attr_reader :payroll

    def initialize(payroll)
      @payroll = payroll
    end

    def call
      overtime + vacation_refund + payroll.taxfree_irregular_income
    end
  end
end
