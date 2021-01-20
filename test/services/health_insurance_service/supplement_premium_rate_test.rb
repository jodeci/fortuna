# frozen_string_literal: true
require "test_helper"

module HealthInsuranceService
  class SupplementPremiumRateTest < ActiveSupport::TestCase
    def test_after_202101
      assert_equal 0.0211, HealthInsuranceService::SupplementPremiumRate.call(2021, 1)
    end

    def test_after_201601
      assert_equal 0.0191, HealthInsuranceService::SupplementPremiumRate.call(2016, 1)
    end

    def test_after_203101
      assert_equal 0.02, HealthInsuranceService::SupplementPremiumRate.call(2013, 1)
    end
  end
end
