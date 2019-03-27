# frozen_string_literal: true
module SalaryService
  class BonusIncome
    include Callable
    include Calculatable

    attr_reader :payroll

    def initialize(payroll)
      @payroll = payroll
    end

    def call
      tax = IncomeTaxService::InsurancedSalary.call(payroll)
      return 0 unless tax.positive?
      return 0 unless payroll.salary.regular_income? or payroll.salary.insured_for_labor_and_uninsured_for_health?
      bonus_income
    end
  end
end
