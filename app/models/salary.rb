# frozen_string_literal: true
class Salary < ApplicationRecord
  belongs_to :employee

  def self.by_payroll(employee, period_start, period_end)
    return if employee.end_date and employee.end_date < period_start
    where("employee_id = ? AND start_date < ?", employee.id, period_end)
      .order(start_date: :asc)
      .last
  end
end
