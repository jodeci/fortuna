# frozen_string_literal: true
module CalculationService
  class TotalIncome
    include Callable
    include Calculatable

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
      monthly_wage + payroll.extra_income
    end

    def regular
      monthly_wage + equipment_subsidy + supervisor_allowance +
      overtime + vacation_refund + payroll.extra_income
    end

    def contractor
      monthly_wage + payroll.extra_income
    end

    def parttime
      total_wage + salary.commuting_subsidy + payroll.extra_income
    end

    def advisor
      total_wage + payroll.extra_income
    end
  end
end
