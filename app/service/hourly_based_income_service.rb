# frozen_string_literal: true
class HourlyBasedIncomeService
  attr_reader :payroll, :salary

  def initialize(payroll, salary)
    @payroll = payroll
    @salary = salary
  end

  def run
    {
      加班費: overtime,
      特休折現: vacation_refund,
    }.transform_values(&:to_i)
  end

  private

  def overtime
    payroll.overtimes.map do |i|
      OvertimeService.new(i.hours, salary, payroll.days_in_cycle).send(i.rate)
    end.reduce(:+)
  end

  def vacation_refund
    OvertimeService.new(payroll.vacation_refund_hours, salary, payroll.days_in_cycle).basic
  end
end
