# frozen_string_literal: true
class Statement < ApplicationRecord
  belongs_to :payroll
  has_one :employee, through: :payroll
  delegate :id, to: :employee, prefix: :employee

  def self.by_payroll(year, month)
    Statement.where(year: year, month: month)
  end
end
