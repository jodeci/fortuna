# frozen_string_literal: true
class LunarYear < ApplicationRecord
  has_many :yearend_bonuses, dependent: :restrict_with_error

  scope :ordered, -> { order(year: :desc) }
end
