# frozen_string_literal: true
class Payroll < ApplicationRecord
  belongs_to :employee

  has_many :overtimes, dependent: :destroy
  accepts_nested_attributes_for :overtimes, allow_destroy: true

  has_many :extra_entries, dependent: :destroy
  accepts_nested_attributes_for :extra_entries, allow_destroy: true

  has_many :statements, dependent: :destroy
  accepts_nested_attributes_for :statements, allow_destroy: true

  after_update :build_statements

  def self.by_date(year, month)
    Payroll.where(year: year, month: month).order(employee_id: :desc)
  end

  def find_salary
    Salary.by_payroll(employee, cycle_start, cycle_end)
  end

  def taxable_irregular_income
    extra_entries
      .where("taxable = true and amount > 0")
      .sum(:amount)
  end

  def days_in_cycle
    employee.contractor? ? BusinessCalendarService.new(cycle_start, cycle_end).days : 30
  end

  private

  def build_statements
    StatementBuilderService.new(self).run
  end

  def cycle_start
    Date.new(year, month, 1)
  end

  def cycle_end
    Date.new(year, month, -1)
  end
end
