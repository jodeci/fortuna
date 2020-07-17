# frozen_string_literal: true
class PayrollInitRegularsService
  include Callable

  attr_reader :year, :month

  def initialize(year, month)
    @year = year.to_i
    @month = month.to_i
  end

  def call
    regulars.map { |row| PayrollInitService.call(Employee.find(row.employee_id), year, month) }
  end

  private

  def regulars_bk
    Employee.by_roles_during(
      cycle_start: Date.new(year, month, 1),
      cycle_end: Date.new(year, month, -1),
      roles: %w[boss regular contractor]
    )
  end

  def regulars
    SalaryTracker.on_payroll(year: year, month: month).by_role(role: %w[boss regular contractor])
  end
end
