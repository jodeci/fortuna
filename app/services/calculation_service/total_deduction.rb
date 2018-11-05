# frozen_string_literal: true
module CalculationService
  class TotalDeduction
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

    def basic
      labor_insurance + health_insurance + income_tax + payroll.extra_deductions
    end

    def boss
      basic
    end

    def regular
      basic + supplement_premium + leavetime + sicktime
    end

    def contractor
      basic + supplement_premium + leavetime
    end

    def vendor
      contractor
    end

    def parttime
      basic + supplement_premium
    end

    def advisor
      supplement_premium + income_tax + payroll.extra_deductions
    end

    # 健保費以足月計算，不做天數調整
    def health_insurance
      salary.health_insurance
    end
  end
end
