# frozen_string_literal: true
require "test_helper"

class MinimumWageServiceTest < ActiveSupport::TestCase
  def test_after_201801
    assert_equal 22000, MinimumWageService.call(2018, 1)
  end

  def test_after_201701
    assert_equal 21009, MinimumWageService.call(2017, 1)
  end

  def test_after_201610
    assert_equal 20008, MinimumWageService.call(2016, 10)
  end

  def test_after_201407
    assert_equal 19273, MinimumWageService.call(2014, 7)
  end

  def test_after_201404
    assert_equal 19047, MinimumWageService.call(2014, 4)
  end

  def test_before_201401
    assert_equal 18780, MinimumWageService.call(2013, 12)
  end
end
