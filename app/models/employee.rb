# frozen_string_literal: true
class Employee < ApplicationRecord
  has_many :salaries, dependent: :destroy
  has_many :payrolls, dependent: :destroy
end
