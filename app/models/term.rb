# frozen_string_literal: true
class Term < ApplicationRecord
  belongs_to :employee

  scope :ordered, -> { order(start_date: :desc) }
end
