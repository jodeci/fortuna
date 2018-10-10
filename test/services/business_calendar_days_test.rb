# frozen_string_literal: true
require "test_helper"

class BusinessCalendarDaysTest < ActiveSupport::TestCase
  def test_2018_02
    assert_equal BusinessCalendarDaysService.call(Date.new(2018, 2, 1), Date.new(2018, 2, 28)), 15
  end

  def test_2018_07
    assert_equal BusinessCalendarDaysService.call(Date.new(2018, 7, 1), Date.new(2018, 7, 31)), 22
  end

  def test_2018_02_range
    assert_equal BusinessCalendarDaysService.call(Date.new(2018, 2, 21), Date.new(2018, 2, 28)), 5
  end

  # 無補班日
  def test_2015_05
    assert_equal BusinessCalendarDaysService.call(Date.new(2015, 5, 1), Date.new(2015, 5, 31)), 20
  end
end
