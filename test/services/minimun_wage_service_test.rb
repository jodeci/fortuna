# frozen_string_literal: true
require "test_helper"

class MinimumWageServiceTest < ActiveSupport::TestCase
  def test_after_201801
    assert_equal MinimumWageService.call(2018, 1), 22000
  end

  def test_after_201701
    assert_equal MinimumWageService.call(2017, 1), 21009
  end

  def test_after_201610
    assert_equal MinimumWageService.call(2016, 10), 20008
  end

  def test_after_201407
    assert_equal MinimumWageService.call(2014, 7), 19273
  end

  def test_after_201404
    assert_equal MinimumWageService.call(2014, 4), 19047
  end

  def test_before_201401
    assert_equal MinimumWageService.call(2013, 12), 18780
  end
end
