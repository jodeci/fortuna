# frozen_string_literal: true
module CalculationService
  class IncomeBeforeWithholdings
    include Callable
    include Calculatable

    attr_reader :payroll

    def initialize(payroll)
      @payroll = payroll
    end

    def call
      leavetime + sicktime + payroll.extra_deductions
    end
  end
end
