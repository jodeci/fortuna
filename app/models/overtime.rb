# frozen_string_literal: true
class Overtime < ApplicationRecord
  belongs_to :payroll

  RATE = { "平日": "weekday", "週末": "weekend", "假日": "holiday" }.freeze
end
