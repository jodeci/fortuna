# frozen_string_literal: true
module IncomeTaxService
  class InsurancedAndIrregularIncome
    include Callable
    include Calculatable

    attr_reader :payroll

    def initialize(payroll)
      @payroll = payroll
    end

    def call
      IncomeTaxService::InsurancedSalary.call(payroll) + IncomeTaxService::IrregularIncome.call(payroll)
    end
  end
end
