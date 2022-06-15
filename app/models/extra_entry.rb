# frozen_string_literal: true
class ExtraEntry < ApplicationRecord
  belongs_to :payroll

  INCOME_TYPE = { "薪資": "salary", "補助": "subsidy", "獎金": "bonus" }.freeze

  scope :yearly_subsidy_report, ->(year) {
    includes(:payroll, payroll: :employee)
      .where("amount > 0 AND income_type = ?", :subsidy)
      .joins(:payroll)
      .where(payrolls: { year: year })
  }
end
