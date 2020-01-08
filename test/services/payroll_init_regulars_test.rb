# frozen_string_literal: true
require "test_helper"

class PayrollInitRegularsTest < ActiveSupport::TestCase
  # TODO: should have better stub for :by_roles_during
  def test_initiate_regulars
    3.times { build(:employee) }
    Employee.expects(:by_roles_during).returns(Employee.all)
    PayrollInitService.any_instance.stubs(:call).returns(true)

    assert PayrollInitRegularsService.call(2018, 1)
  end
end
