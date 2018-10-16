# frozen_string_literal: true
require "test_helper"

class ExemptionTest < ActiveSupport::TestCase
  def test_after_2018
    assert_equal IncomeTaxService::Exemption.call(2018, 1), 84500
  end

  def test_after_2017
    assert_equal IncomeTaxService::Exemption.call(2017, 1), 73500
  end

  def test_before_2017
    assert_equal IncomeTaxService::Exemption.call(2016, 12), 73000
  end
end
