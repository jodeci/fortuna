# frozen_string_literal: true
class Payroll < ApplicationRecord
  belongs_to :employee
  has_many :overtimes, dependent: :destroy
  has_many :extra_entries, dependent: :destroy

  def find_salary
    Salary.by_payroll(employee, Date.new(year, month, 1), Date.new(year, month, -1))
  end

  # TODO: 計算工作天
  def days_in_month
    # employee.contractor? ? 20 : 30
    30
  end
end
