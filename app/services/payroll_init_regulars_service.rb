# frozen_string_literal: true
class PayrollInitRegularsService
  include Callable

  attr_reader :year, :month

  def initialize(year, month)
    @year = year.to_i
    @month = month.to_i
  end

  def call
    init_payroll_for_regulars
  end

  private

  def init_payroll_for_regulars
    regulars.map { |employee| PayrollInitService.call(employee, year, month) }
  end

  def regulars
    Employee.by_roles_during(
      cycle_start: Date.new(year, month, 1),
      cycle_end: Date.new(year, month, -1),
      roles: %w[boss regular contractor]
    )
  end
end
