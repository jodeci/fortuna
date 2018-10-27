# frozen_string_literal: true
module HealthInsuranceService
  class SupplementPremium
    include Callable
    include Calculatable

    attr_reader :payroll

    def initialize(payroll)
      @payroll = payroll
    end

    def call
      return 0 unless eligible?
      premium
    end

    private

    def premium
      (premium_base * rate).round
    end

    def rate
      0.0191
    end

    def eligible?
    end

    def premium_base
    end

    def exemption
    end
  end
end
