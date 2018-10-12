# frozen_string_literal: true
module CalculationService
  class TotalDeduction
    include Callable
    include PayrollPeriodCountable

    attr_reader :payroll, :salary

    def initialize(payroll)
      @payroll = payroll
      @salary = payroll.salary
    end

    def call
      send(salary.role)
    end

    private

    def basic
      labor_insurance + health_insurance + supplement_premium + income_tax + payroll.extra_deductions
    end

    def boss
      basic
    end

    def regular
      basic + leavetime + sicktime
    end

    def contractor
      basic + leavetime
    end

    def parttime
      basic
    end

    def advisor
      supplement_premium + income_tax + payroll.extra_deductions
    end

    def income_tax
      TaxService.call(payroll)
    end

    def labor_insurance
      scale_for_30_days(salary.labor_insurance).round
    end

    def health_insurance
      salary.health_insurance
    end

    def supplement_premium
      SupplementHealthInsuranceService.call(payroll)
    end

    def leavetime
      CalculationService::Leavetime.call(payroll)
    end

    def sicktime
      CalculationService::Sicktime.call(payroll)
    end
  end
end
