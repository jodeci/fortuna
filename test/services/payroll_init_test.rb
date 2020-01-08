# frozen_string_literal: true
require "test_helper"

class PayrollInitTest < ActiveSupport::TestCase
  def test_initiate_payroll
    employee = build(:employee)
    salary = build(:salary, employee: employee)

    SalaryService::Finder.any_instance.expects(:call).returns(salary)
    StatementService::Builder.any_instance.expects(:call).returns(true)

    assert PayrollInitService.call(employee, 2018, 1)
  end
end
