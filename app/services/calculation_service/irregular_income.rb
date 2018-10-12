# frozen_string_literal: true
module CalculationService
  class IrregularIncome
    include Callable

    attr_reader :payroll

    def initialize(payroll)
      @payroll = payroll
    end

    def call
      overtime + vacation_refund + payroll.taxfree_irregular_income
    end

    private

    def overtime
      payroll.overtimes.reduce(0) do |sum, overtime|
        sum + CalculationService::Overtime.call(overtime)
      end
    end

    def vacation_refund
      CalculationService::VacationRefund.call(payroll)
    end
  end
end
