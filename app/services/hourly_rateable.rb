# frozen_string_literal: true
module HourlyRateable
  def hourly_rate
    (income_with_subsidies / days_in_month / 8.0).round
  end

  private

  def income_with_subsidies
    (salary.monthly_wage / salary.monthly_wage_adjustment) +
    salary.supervisor_allowance +
    salary.equipment_subsidy +
    salary.commuting_subsidy
  end
end
