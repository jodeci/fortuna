# frozen_string_literal: true
class Overtime < ApplicationRecord
  belongs_to :payroll

  RATE = { "平日": "weekday", "週末": "weekend", "假日": "holiday" }.freeze

  class << self
    def yearly_report(year)
      Overtime.includes(:payroll, payroll: [:employee, :salary])
        .where("date BETWEEN ? AND ?", Date.new(year, 1, 1), Date.new(year, 12, -1))
    end
  end
end
