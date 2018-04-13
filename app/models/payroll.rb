# frozen_string_literal: true
class Payroll < ApplicationRecord
  belongs_to :employee

  has_many :overtimes, dependent: :destroy
  accepts_nested_attributes_for :overtimes, allow_destroy: true

  has_many :extra_entries, dependent: :destroy
  accepts_nested_attributes_for :extra_entries, allow_destroy: true

  has_one :statement, dependent: :destroy
  after_update :build_statement

  scope :ordered, -> { order(year: :desc, month: :desc) }

  def salary
    Salary.by_payroll(employee, cycle_start, cycle_end)
  end

  def taxable_irregular_income
    extra_entries
      .where("taxable = true and amount > 0")
      .sum(:amount)
  end

  def role
    ActiveDecorator::Decorator.instance.decorate(salary).role_name
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
