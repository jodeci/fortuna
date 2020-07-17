# frozen_string_literal: true
require "test_helper"

class PayrollInitServiceTest < ActiveSupport::TestCase
  def test_initiate_payroll
    employee = build(:employee)
    salary = build(:salary, employee: employee)

    StatementService::Builder.any_instance.expects(:call).returns(true)

    assert PayrollInitService.call(2018, 1, employee.id, salary.id)
  end
end
