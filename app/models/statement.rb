# frozen_string_literal: true
class Statement < ApplicationRecord
  belongs_to :payroll
  has_one :employee, through: :payroll
  delegate :id, to: :employee, prefix: :employee

  class << self
    def paid
      Statement.where("amount > 0")
    end

    def ordered
      Statement.includes(:payroll, payroll: :employee)
        .order("payrolls.employee_id DESC")
    end

    def by_payroll(year, month)
      Statement.where(year: year, month: month)
    end
  end
end
