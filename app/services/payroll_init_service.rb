# frozen_string_literal: true
class PayrollInitService
  include Callable

  attr_reader :employee, :year, :month

  def initialize(employee, year, month)
    @employee = employee
    @year = year
    @month = month
  end

  def call
    generate_payroll
    sync_statement
  end

  private

  def payroll
    Payroll.find_or_initialize_by(year: year, month: month, employee: employee, salary: salary)
  end

  def salary
    employee.find_salary(Date.new(year, month, 1), Date.new(year, month, -1))
  end

  def generate_payroll
    payroll.save
  end

  def sync_statement
    StatementService::Builder.call(payroll)
  end
end
