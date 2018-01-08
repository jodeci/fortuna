# frozen_string_literal: true
class Payroll < ApplicationRecord
  belongs_to :employee
  has_many :overtimes, dependent: :destroy
  has_many :bonuses, dependent: :destroy

  def find_salary
    Salary.by_payroll(employee, Date.new(year, month, 1), Date.new(year, month, -1))
  end
end
