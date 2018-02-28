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
    emp.payrolls.each { |payroll| StatementService.new(payroll).build }
    assert_equal emp.payrolls.length, emp.statements.length
  end
end
