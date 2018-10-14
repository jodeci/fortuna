# frozen_string_literal: true
class BusinessCalendarDaysService
  include Callable

  attr_reader :cycle_start, :cycle_end, :year, :month

  def initialize(cycle_start, cycle_end)
    @cycle_start = cycle_start
    @cycle_end = cycle_end
    @year = cycle_start.year
    @month = cycle_start.month
  end

  def call
    days_in_cycle.size - non_working_days
  end

  private

  def non_working_days
    weekends_in_cycle + dates_in_cycle("holidays") - dates_in_cycle("makeup_days")
  end

  def days_in_cycle
    (cycle_start..cycle_end).to_a
  end

  def weekends_in_cycle
    days_in_cycle.select { |day| [0, 6].include?(day.wday) }.size
  end

  def dates_in_cycle(type)
    days_in_cycle.select { |day| select_dates(type).include? day }.size
  end

  def select_dates(type)
    return [] unless table[type]
    table[type].select { |item| item == month }.values.flatten(2).map { |day| Date.new(year, month, day) }
  end

  def table
    YAML.load_file("#{Rails.root}/config/holidays/#{year}.yml")
  end
end
