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
      monthly_wage + extra_income + payroll.festival_bonus
    end

    def regular
      monthly_wage + equipment_subsidy + supervisor_allowance + commuting_subsidy +
      overtime + vacation_refund + extra_income + payroll.festival_bonus
    end

    def contractor
      monthly_wage + overtime + extra_income + equipment_subsidy + payroll.festival_bonus
    end

    def vendor
      monthly_wage + extra_income
    end

    def parttime
      total_wage + salary.commuting_subsidy + extra_income + payroll.festival_bonus
    end

    def advisor
      total_wage + extra_income
    end
  end
end
