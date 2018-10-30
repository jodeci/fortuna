# frozen_string_literal: true
class PayrollDetail < ApplicationRecord
  class << self
    def owner_income(year:, month:)
      PayrollDetail.find_by(year: year, month: month, owner: true)
    end

    def yearly_bonus_total_until(year:, month:, employee_id:)
      PayrollDetail
        .where(employee_id: employee_id, year: year, splits: nil, tax_code: 50, owner: false)
        .where("excess_income > 0 AND month <= ?", month)
        .sum(:excess_income)
    end

    def monthly_excess_payment(year:, month:)
      PayrollDetail
        .where(year: year, month: month, splits: nil, tax_code: 50, owner: false)
        .where("excess_income > 0")
    end
  end
end
