# frozen_string_literal: true
require "test_helper"

class BusinessCalendarDaysServiceTest < ActiveSupport::TestCase
  def test_2018_02
    assert_equal 15, BusinessCalendarDaysService.call(Date.new(2018, 2, 1), Date.new(2018, 2, 28))
  end

  def test_2018_07
    assert_equal 22, BusinessCalendarDaysService.call(Date.new(2018, 7, 1), Date.new(2018, 7, 31))
  end

  def test_2018_02_range
    assert_equal 5, BusinessCalendarDaysService.call(Date.new(2018, 2, 21), Date.new(2018, 2, 28))
  end

  # 無補班日
  def test_2015_05
    assert_equal 20, BusinessCalendarDaysService.call(Date.new(2015, 5, 1), Date.new(2015, 5, 31))
  end
end
