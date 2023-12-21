# frozen_string_literal: true
module CalculationService
  class Overtime
    include Callable

    attr_reader :hours, :salary, :rate

    def initialize(overtime)
      @hours = overtime.hours
      @salary = overtime.payroll.salary
      @rate = overtime.rate
    end

    def call
      send(rate)
    end

    private

    # 平日加班
    def weekday
      if hours <= 2
        initial_rate * hours
      else
        (initial_rate * 2) + (additional_rate * (hours - 2))
      end
    end

    # 休息日加班（週六）
    def weekend
      if hours <= 8
        weekday
      else
        (initial_rate * 2) + (additional_rate * 6) + (final_rate * 4)
      end
    end

    # 例假日加班（國定假日）
    def holiday
      if hours <= 8
        holiday_rate
      elsif hours <= 10
        holiday_rate + (initial_rate * (hours - 8))
      else
        holiday_rate + (initial_rate * 2) + (additional_rate * (hours - 10))
      end
    end

    # 休假日加班（週日）
    def offday
      if hours <= 8
        holiday_rate
      else
        holiday_rate + (hourly_rate * 4 * 2)
      end
    end

    def hourly_rate
      (salary.income_with_subsidies / 30 / 8.0).ceil.to_i
    end

    def initial_rate
      (hourly_rate * 4 / 3.0).ceil.to_i
    end

    def additional_rate
      (hourly_rate * 5 / 3.0).ceil.to_i
    end

    def final_rate
      (hourly_rate * 8 / 3.0).ceil.to_i
    end

    def holiday_rate
      hourly_rate * 8
    end
  end
end
