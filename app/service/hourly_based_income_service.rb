# frozen_string_literal: true
class HourlyBasedIncomeService
  attr_reader :payroll, :salary

  def initialize(payroll, salary)
    @payroll = payroll
    @salary = salary
  end

  def run
    {
      vacation_refund: vacation_refund,
      overtime: overtime,
    }.transform_values(&:to_i)
  end

  private

  def overtime
    payroll.overtimes.map { |i| OvertimeService.new(i.hours, salary).send(i.rate) }.reduce(:+)
  end

  def vacation_refund
    OvertimeService.new(payroll.vacation_refund_hours, salary).basic
  end
end
