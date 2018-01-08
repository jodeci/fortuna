# frozen_string_literal: true
class IncomeService
  attr_reader :payroll, :salary

  def initialize(payroll, salary)
    @payroll = payroll
    @salary = salary
  end

  def run
    hash = monthly_based.merge(fixed_amount)
    hash[:bonus] = bonus
    hash
  end

  private

  def monthly_based
    MonthlyBasedIncomeService.new(payroll, salary).run
  end

  def fixed_amount
    FixedAmountIncomeService.new(payroll, salary).run
  end

  def bonus
    hash = {}
    payroll.bonuses.map { |i| hash[i.title] = i.amount }
    hash
  end
end
