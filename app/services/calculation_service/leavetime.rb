# frozen_string_literal: true
module CalculationService
  class Leavetime
    include Callable

    attr_reader :hours, :salary, :payroll

    def initialize(payroll)
      @hours = payroll.leavetime_hours
      @salary = payroll.salary
      @payroll = payroll
    end

    def call
      (hours * hourly_rate).to_i
    end

    private

    def hourly_rate
      (salary.income_with_subsidies / days_in_month / 8.0).ceil
    end

    def days_in_month
      if salary.business_calendar?
        BusinessCalendarDaysService.call(cycle_start, cycle_end)
      else
        30
      end
    end

    def cycle_start
      Date.new(payroll.year, payroll.month, 1)
    end

    def cycle_end
      Date.new(payroll.year, payroll.month, -1)
    end
  end
end
