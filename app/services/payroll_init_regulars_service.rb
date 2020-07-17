# frozen_string_literal: true
class PayrollInitRegularsService
  include Callable

  attr_reader :year, :month

  def initialize(year, month)
    @year = year.to_i
    @month = month.to_i
  end

  def call
    regulars.map { |tracker| PayrollInitService.call(year, month, tracker.employee_id, tracker.salary_id) }
  end

  private

  def regulars
    SalaryTracker.on_payroll(year: year, month: month).by_role(role: %w[boss regular contractor])
  end
end
