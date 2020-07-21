# frozen_string_literal: true
class Statement < ApplicationRecord
  belongs_to :payroll

  has_one :employee, through: :payroll
  delegate :id, :name, :id_number, :bank_transfer_type, to: :employee, prefix: true

  has_many :corrections, dependent: :destroy
  accepts_nested_attributes_for :corrections, allow_destroy: true

  scope :paid, -> { where("statements.amount > 0") }
  scope :by_payroll, ->(year, month) { where(year: year, month: month) }

  scope :ordered, -> {
    includes(:payroll, :employee, :corrections, payroll: [:salary, :employee])
      .order("payrolls.employee_id DESC")
  }
end
