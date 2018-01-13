# frozen_string_literal: true
class LeavetimeService
  include HourlyRateable

  attr_reader :hours, :salary, :days_in_month

  def initialize(hours, salary, days_in_month = 30)
    @hours = hours
    @salary = salary
    @days_in_month = days_in_month
  end

  def normal
    (hours * hourly_rate).to_i
  end

  def sick
    (normal * 0.5).round
  end
end
