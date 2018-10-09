# frozen_string_literal: true
class Payroll < ApplicationRecord
  include Givenable

  belongs_to :employee
  belongs_to :salary

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

    def between(start_point, end_point)
      result = []
      date_range_to_years_and_months(start_point, end_point).map do |date|
        result << find_by(year: date[0], month: date[1])
      end
      result
    end

    private

    def date_range_to_years_and_months(start_point, end_point)
      result = []
      (start_point...end_point).each_with_index do |element, index|
        next if element.day > 1 and index > 1
        result << [element.year, element.month]
      end
      result
    end
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
end
