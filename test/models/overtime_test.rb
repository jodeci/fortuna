# frozen_string_literal: true
require "test_helper"

class OvertimeTest < ActiveSupport::TestCase
  setup do
    create(:overtime, date: "2017-02-01", payroll: build(:payroll))
    create(:overtime, date: "2018-03-15", payroll: build(:payroll))
    create(:overtime, date: "2018-04-15", payroll: build(:payroll))
  end

  def test_yearly_report
    assert_equal 1, Overtime.yearly_report(2017).count
    assert_equal 2, Overtime.yearly_report(2018).count
  end
end
