# frozen_string_literal: true
module CalculationService
  class TotalIncome
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

    def boss
      scale_for_cycle(salary.monthly_wage) + payroll.extra_income
    end

    def regular
      scale_for_cycle(salary.monthly_wage + salary.equipment_subsidy + salary.supervisor_allowance) +
      overtime + vacation_refund + payroll.extra_income
    end

    def contractor
      scale_for_cycle(salary.monthly_wage) + payroll.extra_income
    end

    def parttime
      total_wage + salary.commuting_subsidy + payroll.extra_income
    end

    def advisor
      total_wage + payroll.extra_income
    end

    def total_wage
      (payroll.parttime_hours * salary.hourly_wage).round
    end

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
