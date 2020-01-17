# frozen_string_literal: true
class PayrollInitRegularsService
  include Callable

  attr_reader :year, :month

  def initialize(year, month)
    @year = year.to_i
    @month = month.to_i
  end

  def call
    regulars.map { |employee| PayrollInitService.call(employee, year, month) }
  end

  private

  def regulars
    Employee.by_roles_during(
      cycle_start: Date.new(year, month, 1),
      cycle_end: Date.new(year, month, -1),
      roles: %w[boss regular contractor]
    )
  end
end
