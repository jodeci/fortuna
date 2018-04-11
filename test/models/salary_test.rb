# frozen_string_literal: true
require "test_helper"

class SalaryTest < ActiveSupport::TestCase
  def test_salary_before_onboard
    employee = build(:employee, start_date: "2015-05-13")
    assert_nil Salary.by_payroll(employee, Date.new(2015, 4, 1), Date.new(2015, 4, -1))
  end

  def test_salary_after_termination
    employee = build(:employee, end_date: "2015-05-13")
    assert_nil Salary.by_payroll(employee, Date.new(2015, 6, 1), Date.new(2015, 6, -1))
  end

  def employee_with_salaries
    build(:employee, start_date: "2015-05-13") do |employee|
      create(:salary, monthly_wage: 36000, effective_date: "2015-05-13", employee: employee, role: "regular")
      create(:salary, monthly_wage: 40000, effective_date: "2015-09-01", employee: employee, role: "regular")
    end
  end

  def test_salary_1
    salary = Salary.by_payroll(employee_with_salaries, Date.new(2015, 5, 1), Date.new(2015, 5, -1))
    assert_equal salary.monthly_wage, 36000
  end

  def test_salary_2
    salary = Salary.by_payroll(employee_with_salaries, Date.new(2015, 9, 1), Date.new(2015, 9, -1))
    assert_equal salary.monthly_wage, 40000
  end
end
