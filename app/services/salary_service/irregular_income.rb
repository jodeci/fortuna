# frozen_string_literal: true
module SalaryService
  class IrregularIncome
    include Callable
    include Calculatable

    attr_reader :payroll

    def initialize(payroll)
      @payroll = payroll
    end

    def call
      bonus_income
    end
  end
end
