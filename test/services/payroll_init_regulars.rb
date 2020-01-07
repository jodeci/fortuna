# frozen_string_literal: true
require "test_helper"

class PayrollInitRegularsTest < ActiveSupport::TestCase
  def test_initiate_payrolls
    3.times { build(:employee) }
    Employee.expects(:on_payroll).returns(Employee.all)
    PayrollInitService.any_instance.stubs(:call).returns(true)

    PayrollInitRegularsService.call(2018, 1)
  end
end
