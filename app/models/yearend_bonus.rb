# frozen_string_literal: true
class YearendBonus < ApplicationRecord
  belongs_to :employee
  belongs_to :lunar_year

  class << self
    def fetch(employee, lunar_year)
      find_by(employee: employee, lunar_year: lunar_year) || NullYearendBonus
    end
  end

  def total_amount
    salary_based_bonus + fixed_amount + cash_benefit
  end
end
