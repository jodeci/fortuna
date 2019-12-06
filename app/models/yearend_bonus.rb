# frozen_string_literal: true
class YearendBonus < ApplicationRecord
  belongs_to :employee
  belongs_to :lunar_year

  scope :personal_history, -> { includes(:lunar_year).order("lunar_years.year DESC") }

  class << self
    def fetch(employee, lunar_year)
      find_by(employee: employee, lunar_year: lunar_year) || NullYearendBonus
    end
  end

  def bank_transfer_amount
    total - cash_benefit
  end
end
