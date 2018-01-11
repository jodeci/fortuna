# frozen_string_literal: true
class Payroll < ApplicationRecord
  belongs_to :employee
  has_many :overtimes, dependent: :destroy
  has_many :extra_entries, dependent: :destroy

  def find_salary
    Salary.by_payroll(employee, cycle_start, cycle_end)
  end

  def days_in_cycle
    employee.contractor? ? BusinessCalendarService.new(cycle_start, cycle_end).days : 30
  end

  private

  def cycle_start
    Date.new(year, month, 1)
  end

  def cycle_end
    Date.new(year, month, -1)
  end
end
