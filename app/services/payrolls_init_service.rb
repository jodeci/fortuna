# frozen_string_literal: true
class PayrollsInitService
  include Callable

  attr_reader :year, :month

  def initialize(year, month)
    @year = year
    @month = month
  end

  def call
    find_or_create_payrolls_for_employees
  end

  private

  def find_or_create_payrolls_for_employees
    employees_on_payroll.map do |employee|
      salary = Salary.by_payroll(employee, cycle_start, cycle_end)
      next if salary.nil? or salary.absent? # FIXME: skip nil for development, should let crash
      Payroll.find_or_initialize_by(year: year, month: month, employee: employee, salary: salary).save
    end
  end

  def employees_on_payroll
    Employee.on_payroll(cycle_start, cycle_end)
  end

  def cycle_start
    Date.new(year, month, 1)
  end

  def cycle_end
    Date.new(year, month, -1)
  end
end
