# frozen_string_literal: true
require "test_helper"

module IncomeTaxService
  class ExemptionTest < ActiveSupport::TestCase
    def test_after_2024
      assert_equal 88500, IncomeTaxService::Exemption.call(2024, 1)
    end

    def test_after_2022
      assert_equal 86000, IncomeTaxService::Exemption.call(2022, 1)
    end

    def test_after_2018
      assert_equal 84500, IncomeTaxService::Exemption.call(2018, 1)
    end

    def test_after_2017
      assert_equal 73500, IncomeTaxService::Exemption.call(2017, 1)
    end

    def test_before_2017
      assert_equal 73000, IncomeTaxService::Exemption.call(2016, 12)
    end
  end
end
