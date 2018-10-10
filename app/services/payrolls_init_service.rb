# frozen_string_literal: true
class PayrollsInitService
  include Callable

  attr_reader :year, :month

  def initialize(year, month)
    @year = year
    @month = month
  end

  def call
    init_payroll_for_employees
  end

  private

  def init_payroll_for_employees
    employees_on_payroll.map { |employee| PayrollInitService.call(employee, year, month) }
  end

  def employees_on_payroll
    Employee.on_payroll(Date.new(year, month, 1), Date.new(year, month, -1))
  end
end
