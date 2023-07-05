# frozen_string_literal: true
require "test_helper"

class MinimumWageServiceTest < ActiveSupport::TestCase
  def test_after_202301
    assert_equal 26400, MinimumWageService.call(2023, 1)
  end

  def test_after_202201
    assert_equal 25250, MinimumWageService.call(2022, 1)
  end

  def test_after_202101
    assert_equal 24000, MinimumWageService.call(2021, 1)
  end

  def test_after_202001
    assert_equal 23800, MinimumWageService.call(2020, 1)
  end

  def test_after_201901
    assert_equal 23100, MinimumWageService.call(2019, 1)
  end

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
