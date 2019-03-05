# frozen_string_literal: true
module IncomeTaxService
  class InsurancedSalary
    include Callable

    attr_reader :payroll

    def initialize(payroll)
      @payroll = payroll
    end

    def call
      insuranced_salary_tax
    end

    private

    def insuranced_salary_tax
      payroll.salary.fixed_income_tax
    end
  end
end
