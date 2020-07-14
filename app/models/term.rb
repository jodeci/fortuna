# frozen_string_literal: true
class Term < ApplicationRecord
  belongs_to :employee
  has_many :salaries, dependent: :restrict_with_error

  scope :ordered, -> { order(start_date: :desc) }
end
