# frozen_string_literal: true
module IncomeTaxService
  class Dispatcher
    include Callable

    attr_reader :payroll, :salary

    def initialize(payroll)
      @payroll = payroll
      @salary = payroll.salary
    end

    def call
      return 0 if payroll.employee.b2b?
      dispatch
    end

    private

    def dispatch
      if salary.professional_service?
        IncomeTaxService::ProfessionalService.call(payroll)
      elsif salary.parttime_income_uninsured_for_labor?
        IncomeTaxService::UninsurancedSalary.call(payroll)
      else
        IncomeTaxService::RegularEmployee.call(payroll)
      end
    end
  end
end
