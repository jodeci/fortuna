# frozen_string_literal: true
class PayrollDetail < ApplicationRecord
  class << self
    def owner_income(year:, month:)
      find_by(year: year, month: month, owner: true)
    end

    def monthly_salary(year:, month:)
      where(year: year, month: month, owner: false, tax_code: 50)
        .where("insured_for_health > 0")
        .where("amount - subsidy_income > insured_for_health")
    end

    def yearly_bonus_total_until(year:, month:, employee_id:)
      where(employee_id: employee_id, year: year, splits: nil, tax_code: 50)
        .where("excess_income > 0 AND month <= ?", month)
        .sum(:excess_income)
    end

    def monthly_bonus(year:, month:)
      where(year: year, month: month, splits: nil, tax_code: 50)
        .where("insured_for_health > 0 AND excess_income > 0")
    end
  end
end
