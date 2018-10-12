# frozen_string_literal: true
class ExtraEntry < ApplicationRecord
  belongs_to :payroll

  class << self
    def yearly_report(year)
      ExtraEntry.includes(:payroll, payroll: :employee)
        .where("amount > 0 AND taxable = false")
        .joins(:payroll)
        .where("payrolls.year = ?", year)
    end
  end
end
