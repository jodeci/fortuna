# frozen_string_literal: true
class Payroll < ApplicationRecord
  include Givenable

  belongs_to :employee

  has_many :overtimes, dependent: :destroy
  accepts_nested_attributes_for :overtimes, allow_destroy: true

  has_many :extra_entries, dependent: :destroy
  accepts_nested_attributes_for :extra_entries, allow_destroy: true

  has_one :statement, dependent: :destroy
  delegate :amount, to: :statement
  after_update :build_statement

  class << self
    def ordered
      order(year: :desc, month: :desc)
    end

    def service_year(year)
      where("year = ? and month < 12", year)
        .or(where("year = ? and month = 12", year - 1))
    end
  end

  def salary
    Salary.by_payroll(employee, cycle_start, cycle_end)
  end

  def taxable_irregular_income
    extra_entries
      .where("taxable = true and amount > 0")
      .sum(:amount)
  end

  private

  def build_statement
    return if salary.absent?
    StatementService.new(self).build
  end

  def cycle_start
    Date.new(year, month, 1)
  end

  def cycle_end
    Date.new(year, month, -1)
  end
end
