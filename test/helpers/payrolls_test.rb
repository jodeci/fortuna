# frozen_string_literal: true
require "test_helper"

class PayrollsHelperTest < ActionView::TestCase
  def test_with_params
    prepare_params(year: 2017, month: 7)
    assert_equal init_year, 2017
    assert_equal init_month, 7
    assert_equal init_button_text, "產生薪資單：2017-07"
  end

  def test_without_params
    Timecop.freeze(Date.new(2015, 3)) do
      assert_equal init_year, 2015
      assert_equal init_month, 3
      assert_equal init_button_text, "產生薪資單：2015-03"
    end
  end

  private

  def prepare_params(year:, month:)
    @controller = ApplicationController.new
    @controller.send(:params=, query: { year_eq: year, month_eq: month })
  end
end
