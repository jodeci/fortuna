# frozen_string_literal: true
class LeavetimeService
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

  private

  # 由於薪資進項只會針對不足月的天數做調整，請假扣款需以全額計算
  def hourly_rate
    (income_with_subsidies / days_in_month / 8.0).round
  end

  def income_with_subsidies
    salary.base + salary.supervisor_allowance + salary.equipment_subsidy + salary.commuting_subsidy
  end
end
