# frozen_string_literal: true
require "test_helper"

class EmployeeTest < ActiveSupport::TestCase
  def month_salary
    50000
  end

  def emp
    @emp ||= FactoryBot.create :employee_with_payrolls, month_salary: 50000, build_statement_immediatedly: false
  end

  def months_until_now
    TimeDifference.between(emp.start_date, Date.today).in_months.round
  end

  def test_has_least_one_salary_record
    assert_operator emp.salaries.length, :>, 0
  end

  def test_has_payrolls_until_next_month
    assert_equal emp.payrolls.length, months_until_now
  end

  def test_has_all_payrolls_with_same_salary
    assert_equal emp.payrolls.map(&:salary).size, emp.payrolls.length
  end

  def test_has_same_amount_between_payrolls_and_statements
    emp.payrolls.each { |payroll| StatementService.call(payroll) }
    assert_equal emp.payrolls.length, emp.statements.length
  end

  def test_salary_before_onboard
    employee = build(:employee, start_date: "2015-05-13")
    assert_nil employee.find_salary(Date.new(2015, 4, 1), Date.new(2015, 4, -1))
  end

  def test_salary_after_termination
    employee = build(:employee, end_date: "2015-05-13")
    assert_nil employee.find_salary(Date.new(2015, 6, 1), Date.new(2015, 6, -1))
  end

  def employee_with_salaries
    build(:employee, start_date: "2015-05-13") do |employee|
      create(:salary, monthly_wage: 36000, effective_date: "2015-05-13", employee: employee, role: "regular")
      create(:salary, monthly_wage: 40000, effective_date: "2015-09-01", employee: employee, role: "regular")
    end
  end

  def test_find_salary_1
    salary = employee_with_salaries.find_salary(Date.new(2015, 5, 1), Date.new(2015, 5, -1))
    assert_equal salary.monthly_wage, 36000
  end

  def test_find_salary_2
    salary = employee_with_salaries.find_salary(Date.new(2015, 9, 1), Date.new(2015, 9, -1))
    assert_equal salary.monthly_wage, 40000
  end
end
