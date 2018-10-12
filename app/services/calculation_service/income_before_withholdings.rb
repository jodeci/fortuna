# frozen_string_literal: true
module CalculationService
  class IncomeBeforeWithholdings
    include Callable

    attr_reader :payroll

    def initialize(payroll)
      @payroll = payroll
    end

    def call
      leavetime + sicktime + payroll.extra_deductions
    end

    private

    def leavetime
      CalculationService::Leavetime.call(payroll)
    end

    def sicktime
      CalculationService::Sicktime.call(payroll)
    end
  end
end
