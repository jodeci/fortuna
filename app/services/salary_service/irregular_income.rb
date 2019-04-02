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
      return 0 unless payroll.salary.regular_income? or payroll.salary.insured_for_labor_and_uninsured_for_health?
      bonus_income + payroll.extra_income_of(:salary)
    end
  end
end
