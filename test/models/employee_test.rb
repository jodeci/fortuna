# frozen_string_literal: true
require "test_helper"

class EmployeeTest < ActiveSupport::TestCase
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
    emp.payrolls.each { |payroll| StatementService::Builder.call(payroll) }
    assert_equal emp.payrolls.length, emp.statements.length
  end

  def test_find_salary
    employee = build(:employee, start_date: "2015-05-13", end_date: "2016-11-15")
    salary1 = create(:salary, effective_date: "2015-05-13", employee: employee)
    salary2 = create(:salary, effective_date: "2015-09-01", employee: employee)

    assert_nil employee.find_salary(Date.new(2015, 4, 1), Date.new(2015, 4, -1))
    assert_equal salary1, employee.find_salary(Date.new(2015, 5, 1), Date.new(2015, 5, -1))
    assert_equal salary2, employee.find_salary(Date.new(2015, 9, 1), Date.new(2015, 9, -1))
    assert_nil employee.find_salary(Date.new(2016, 12, 1), Date.new(2016, 12, -1))
  end

  def test_email
    assert_equal "john@5xruby.tw", john.email
    assert_equal "jack@gmail.com", jack.email
    assert_equal "jane@gmail.com", jane.email
  end

  def test_resigned
    assert jack.resigned?
    assert_not john.resigned?
  end

  def test_scope_on_payroll_201802
    Timecop.freeze(Date.new(2018, 2, 19)) do
      assert Employee.on_payroll(Date.new(2018, 2, 1), Date.new(2018, 2, -1)).include? john
      assert Employee.on_payroll(Date.new(2018, 2, 1), Date.new(2018, 2, -1)).include? jack
      assert_not Employee.on_payroll(Date.new(2018, 2, 1), Date.new(2018, 2, -1)).include? jane
    end
  end

  def test_scope_on_payroll_201805
    Timecop.freeze(Date.new(2018, 5, 20)) do
      assert Employee.on_payroll(Date.new(2018, 5, 1), Date.new(2018, 5, -1)).include? john
      assert_not Employee.on_payroll(Date.new(2018, 5, 1), Date.new(2018, 5, -1)).include? jack
      assert Employee.on_payroll(Date.new(2018, 5, 1), Date.new(2018, 5, -1)).include? jane
    end
  end

  def test_scope_active
    Timecop.freeze(Date.new(2017, 12, 13)) do
      assert Employee.active.include? john
      assert Employee.active.include? jack
    end

    Timecop.freeze(Date.new(2018, 3, 1)) do
      assert Employee.active.include? john
      assert_not Employee.active.include? jack
    end
  end

  def test_scope_inactive
    Timecop.freeze(Date.new(2017, 12, 13)) do
      assert_not Employee.inactive.include? jack
      assert_not Employee.inactive.include? john
    end

    Timecop.freeze(Date.new(2018, 3, 1)) do
      assert Employee.inactive.include? jack
      assert_not Employee.inactive.include? john
    end
  end

  def test_scope_ordered
    5.times { create(:employee) }
    assert Employee.ordered.each_cons(2).all? { |first, second| first.id >= second.id }
  end

  private

  def emp
    @emp ||= create(:employee_with_payrolls, month_salary: 50000, build_statement_immediatedly: false)
  end

  def months_until_now
    TimeDifference.between(emp.start_date, Date.today).in_months.round
  end

  def john
    @john ||= create(:employee, start_date: "2017-01-01", company_email: "john@5xruby.tw", personal_email: "john@gmail.com")
  end

  def jack
    @jack ||= create(:employee, start_date: "2017-10-01", end_date: "2018-02-06", company_email: "jack@5xruby.tw", personal_email: "jack@gmail.com")
  end

  def jane
    @jane ||= create(:employee, start_date: "2018-03-01", company_email: nil, personal_email: "jane@gmail.com")
  end
end
