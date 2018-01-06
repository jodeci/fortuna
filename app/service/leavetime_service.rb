# frozen_string_literal: true
class LeavetimeService
  attr_reader :hours, :salary

  def initialize(hours, salary)
    @hours = hours
    @salary = salary
  end

  def run
    hours * hourly_rate
  end

  private

  # 由於薪資進項只會針對不足月的天數做調整，請假扣款需以全額計算
  def hourly_rate
    (income_with_subsidies / 30 / 8.0).round
  end

  def income_with_subsidies
    salary.base + salary.supervisor_allowance + salary.equipment_subsidy + salary.commuting_subsidy
  end
end
