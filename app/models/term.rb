# frozen_string_literal: true
class Term < ApplicationRecord
  belongs_to :employee

  class << self
    def ordered
      Term.order(start_date: :desc)
    end
  end
end
