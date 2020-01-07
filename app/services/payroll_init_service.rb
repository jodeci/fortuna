# frozen_string_literal: true
class PayrollInitService
  include Callable

  attr_reader :employee, :year, :month

  def initialize(employee, year, month)
    @employee = employee
    @year = year.to_i
    @month = month.to_i
  end

  def call
    generate_payroll
    sync_statement
  end

  private

  def payroll
    @payroll ||= Payroll.find_or_initialize_by(year: year, month: month, employee: employee)
  end

  def generate_payroll
    payroll.salary = SalaryService::Finder.call(employee, Date.new(year, month, 1), Date.new(year, month, -1))
    payroll.save
  end

  def sync_statement
    StatementService::Builder.call(payroll)
  end
end
