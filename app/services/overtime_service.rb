# frozen_string_literal: true
class OvertimeService
  include Callable
  include HourlyRateable

  attr_reader :hours, :salary, :rate

  def initialize(overtime)
    @hours = overtime.hours
    @salary = overtime.payroll.salary
    @rate = overtime.rate
  end

  def call
    send(rate)
  end

  # 一例一休 平日加班
  def weekday
    if hours <= 2
      (initial_rate * hours).to_i
    else
      (initial_rate * 2 + additional_rate * (hours - 2)).to_i
    end
  end

  # 一例一休 週末加班
  def weekend
    if hours <= 8
      weekday
    else
      (initial_rate * 2 + additional_rate * 6 + final_rate * (hours - 8)).to_i
    end
  end

  # 一例一休 假日加班
  def holiday
    (hourly_rate * 8 * 2).to_i
  end

  private

  def days_in_month
    30
  end

  def initial_rate
    hourly_rate * 4 / 3
  end

  def additional_rate
    hourly_rate * 5 / 3
  end

  def final_rate
    additional_rate + hourly_rate
  end
end
