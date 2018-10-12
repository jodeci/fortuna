# frozen_string_literal: true
class Payroll < ApplicationRecord
  include Givenable

  belongs_to :employee
  belongs_to :salary # 間接關聯，詳見 SalaryService

  has_many :overtimes, dependent: :destroy
  accepts_nested_attributes_for :overtimes, allow_destroy: true

  has_many :extra_entries, dependent: :destroy
  accepts_nested_attributes_for :extra_entries, allow_destroy: true

  has_one :statement, dependent: :destroy

  class << self
    def ordered
      order(year: :desc, month: :desc)
    end

    def search_result
      includes(:employee, :salary, :statement)
        .order(employee_id: :desc)
    end

    def personal_history
      includes(:salary, :statement, statement: :corrections)
    end

    def details
      includes(:salary, :extra_entries, :overtimes)
    end

    def yearly_vacation_refunds(year)
      includes(:employee, :salary)
        .where("vacation_refund_hours > 0 and year = ?", year)
    end
  end

  def find_salary
    Salary.by_payroll(employee, Date.new(year, month, 1), Date.new(year, month, -1))
  end

  def taxable_irregular_income
    extra_entries
      .where("taxable = true and amount > 0")
      .sum(:amount)
  end

  def taxfree_irregular_income
    extra_entries
      .where("taxable = false and amount > 0")
      .sum(:amount)
  end

  def extra_income
    extra_entries
      .where("amount > 0")
      .sum(:amount)
  end

  def extra_deductions
    extra_entries
      .where("amount < 0")
      .sum(:amount)
  end
end
