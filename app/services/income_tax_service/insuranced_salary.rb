# frozen_string_literal: true
module IncomeTaxService
  class InsurancedSalary
    include Callable
    include Calculatable

    attr_reader :payroll, :call_type

    def initialize(payroll)
      @payroll = payroll
    end

    def call
      insuranced_salary_tax
    end
  end
end
