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
      本薪: base_salary,
      伙食費: taxfree_lunch,
      設備津貼: salary.equipment_subsidy,
      主管加給: salary.supervisor_allowance,
    }.transform_values { |v| adjust_for_incomplete_month(v) }
  end

  private

  def base_salary
    salary.monthly_wage - taxfree_lunch
  end

  def taxfree_lunch
    payroll.year >= 2015 ? 2400 : 1800
  end
end
