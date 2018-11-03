# frozen_string_literal: true
require "test_helper"

class PayrollsHelperTest < ActionView::TestCase
  def test_with_params
    prepare_params(year: 2017, month: 7)
    assert_equal 2017, init_year
    assert_equal 7, init_month
    assert_equal "產生薪資單：2017-07", init_button_text
  end

  def test_without_params
    Timecop.freeze(Date.new(2015, 3)) do
      assert_equal 2015, init_year
      assert_equal 3, init_month
      assert_equal "產生薪資單：2015-03", init_button_text
    end
  end

  private

  def prepare_params(year:, month:)
    @controller = ApplicationController.new
    @controller.send(:params=, query: { year_eq: year, month_eq: month })
  end
end
