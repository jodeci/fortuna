# frozen_string_literal: true
module HealthInsuranceService
  class SupplementPremiumRate
    include Callable

    attr_reader :date

    def initialize(year, month)
      @date = Date.new(year, month, 1)
    end

    def call
      if date >= Date.new(2021, 1, 1)
        0.0211
      elsif date >= Date.new(2016, 1, 1)
        0.0191
      else
        0.02
      end
    end
  end
end
