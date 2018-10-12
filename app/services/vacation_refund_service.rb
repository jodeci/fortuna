# frozen_string_literal: true
class VacationRefundService
  include Callable

  attr_reader :hours, :salary

  def initialize(payroll)
    @hours = payroll.vacation_refund_hours
    @salary = payroll.salary
  end

  def call
    (hourly_rate * hours).to_i
  end

  private

  def hourly_rate
    (salary.income_with_subsidies / 30 / 8.0).round
  end
end
