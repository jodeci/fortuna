# frozen_string_literal: true
class IncomeService
  attr_reader :payroll, :salary

  def initialize(payroll, salary)
    @payroll = payroll
    @salary = salary
  end

  def run
    hash = monthly_based.merge(hourly_based)
    hash[:extra] = extra_gain
    hash
  end

  private

  def monthly_based
    MonthlyBasedIncomeService.new(payroll, salary).run
  end

  def hourly_based
    HourlyBasedIncomeService.new(payroll, salary).run
  end

  def extra_gain
    ExtraEntriesService.new(payroll).gain
  end
end
