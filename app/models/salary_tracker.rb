# frozen_string_literal: true
class SalaryTracker < ApplicationRecord
  class << self
    def on_payroll(year: Date.today.year, month: Date.today.month)
      select("DISTINCT ON (employee_id) *")
        .where("term_start <= ?", Date.new(year, month, 1))
        .where("(term_end >= ? OR term_end IS NULL)", Date.new(year, month, -1))
        .where("salary_start <= ?", Date.new(year, month, -1))
        .order(employee_id: :desc, salary_start: :desc)
    end

    def by_role(role:)
      where(role: role)
    end

    def inactive(year: Date.today.year, month: Date.today.month)
      select("DISTINCT ON (employee_id) *")
        .where.not(employee_id: active_terms)
        .where("term_end <= ?", Date.new(year, month, -1))
        .order(employee_id: :desc)
    end

    def salary_by_payroll(payroll:)
      where(employee_id: payroll.employee_id)
        .where("term_start <= ?", Date.new(payroll.year, payroll.month, 1))
        .where("salary_start <= ?", Date.new(payroll.year, payroll.month, -1))
        .order(salary_start: :desc)
        .pluck(:salary_id)
        .first
    end

    def term_by_salary(salary_id:)
      select(:term_start, :term_end).find_by(salary_id: salary_id)
    end

    private

    def active_terms
      select(:employee_id).distinct.where(term_end: nil)
    end
  end
end
