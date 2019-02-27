# frozen_string_literal: true
class PayrollDetail < ApplicationRecord
  scope :owner_income, ->(year:, month:) { find_by(year: year, month: month, owner: true) }

  scope :yearly_bonus_total_until, ->(year:, month:, employee_id:) {
    where(employee_id: employee_id, year: year, splits: nil, tax_code: 50, owner: false)
      .where("excess_income > 0 AND month <= ?", month)
      .sum(:excess_income)
  }

  scope :monthly_excess_payment, ->(year:, month:) {
    where(year: year, month: month, splits: nil, tax_code: 50, owner: false)
      .where("excess_income > 0")
  }
end
