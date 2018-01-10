# frozen_string_literal: true
class MonthlyBasedIncomeService
  include PayrollPeriodCountable

  attr_reader :payroll, :salary

  def initialize(payroll, salary)
    @payroll = payroll
    @salary = salary
  end

  def run
    {
      base: base_salary,
      taxfree_lunch: taxfree_lunch,
      equipment_subsidy: salary.equipment_subsidy,
      commuting_subsidy: salary.commuting_subsidy,
      supervisor_allowance: salary.supervisor_allowance,
    }.transform_values { |v| adjust_for_incomplete_month(v) }
  end

  private

  def base_salary
    salary.base - taxfree_lunch
  end

  def taxfree_lunch
    1800
  end
end
