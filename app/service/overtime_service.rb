# frozen_string_literal: true
class OvertimeService
  attr_reader :hours, :salary

  def initialize(hours, salary)
    @hours = hours
    @salary = salary
  end

  # 一例一休 平日加班
  def weekday
    if hours <= 2
      initial_rate * hours
    else
      initial_rate * 2 + additional_rate * (hours - 2)
    end
  end

  # 一例一休 週末加班
  def weekend
    if hours <= 8
      weekday
    else
      initial_rate * 2 + additional_rate * 6 + final_rate * (hours - 8)
    end
  end

  # 一例一休 假日加班
  def holiday
    hourly_rate * 8 * 2
  end

  # 特休換現金
  def basic
    hourly_rate * hours
  end

  private

  def hourly_rate
    ((salary.base + salary.supervisor_allowance) / 30 / 8.0).round
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
