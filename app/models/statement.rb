# frozen_string_literal: true
class Statement < ApplicationRecord
  belongs_to :payroll
  has_one :employee, through: :payroll
  delegate :id, to: :employee, prefix: :employee

  has_many :corrections, dependent: :destroy
  accepts_nested_attributes_for :corrections, allow_destroy: true

  class << self
    def paid
      Statement.where("statements.amount > 0")
    end

    def ordered
      Statement.includes(:payroll, :corrections, payroll: [:salary, :employee])
        .order("payrolls.employee_id DESC")
    end

    def by_payroll(year, month)
      Statement.where(year: year, month: month)
    end
  end

  def corrections?
    corrections.any?
  end

  def correct_by
    corrections.sum(:amount)
  end

  def report_amount
    amount - irregular_income + correct_by
  end
end
