# frozen_string_literal: true
class IncomeService
  attr_reader :payroll

  def initialize(payroll)
    @payroll = payroll
  end

  def run
    hash = monthly_based.merge(fixed_amount)
    hash[:bonus] = bonus
    hash
  end

  private

  def monthly_based
    MonthlyBasedIncomeService.new(payroll).run
  end

  def fixed_amount
    FixedAmountIncomeService.new(payroll).run
  end

  def bonus
    hash = {}
    payroll.bonuses.map { |i| hash[i.title] = i.amount }
    hash
  end
end
