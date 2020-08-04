# frozen_string_literal: true
class PayrollInitService
  include Callable

  attr_reader :year, :month, :employee_id, :salary_id

  def initialize(year, month, employee_id, salary_id)
    @year = year.to_i
    @month = month.to_i
    @employee_id = employee_id
    @salary_id = salary_id
  end

  def call
    payroll
    sync_statement
  end

  private

  def payroll
    @payroll ||= Payroll.find_or_create_by(
      year: year,
      month: month,
      employee_id: employee_id,
      salary_id: salary_id
    )
  end

  def sync_statement
    StatementService::Builder.call(payroll)
  end
end
