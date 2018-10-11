# frozen_string_literal: true
class VacationRefundService
  include Callable
  include HourlyRateable

  attr_reader :hours, :salary

  def initialize(payroll)
    @hours = payroll.vacation_refund_hours
    @salary = payroll.salary
  end

  def call
    (hourly_rate * hours).to_i
  end

  private

  def days_in_month
    30
  end
end
