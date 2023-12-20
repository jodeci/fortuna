# frozen_string_literal: true
module CalculationService
  class Sicktime
    include Callable

    attr_reader :hours, :salary

    def initialize(payroll)
      @hours = payroll.sicktime_hours
      @salary = payroll.salary
    end

    def call
      (hours * hourly_rate * 0.5).to_i
    end

    private

    def hourly_rate
      (salary.income_with_subsidies / 30 / 8.0).ceil
    end
  end
end
