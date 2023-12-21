# frozen_string_literal: true
class Overtime < ApplicationRecord
  belongs_to :payroll
  delegate :year, :month, to: :payroll, prefix: true

  has_one :employee, through: :payroll
  delegate :id, :name, to: :employee, prefix: true

  RATE = { "平日": "weekday", "休息日": "weekend", "休假日": "holiday", "例假日": "offday" }.freeze

  scope :yearly_report, ->(year) {
    includes(:payroll, :employee, payroll: :salary)
      .where("date BETWEEN ? AND ?", Date.new(year, 1, 1), Date.new(year, 12, -1))
  }
end
