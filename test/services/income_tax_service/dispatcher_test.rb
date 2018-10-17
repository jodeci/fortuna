# frozen_string_literal: true
require "test_helper"
require "minitest/mock"

class DispatcherTest < ActiveSupport::TestCase
  def test_bypass_when_business
    employee = build(:employee, b2b: true)
    salary = build(:salary)
    payroll = build(:payroll, salary: salary, employee: employee)
    assert_equal IncomeTaxService::Dispatcher.call(payroll), 0
  end

  def test_dispatches_to_professional_service
    employee = build(:employee)
    salary = build(:salary, tax_code: "9a")
    payroll = build(:payroll, salary: salary, employee: employee)

    mock = MiniTest::Mock.new
    mock.expect(:call, 0, [payroll])

    IncomeTaxService::ProfessionalService.stub :call, mock do
      assert IncomeTaxService::Dispatcher.call(payroll)
    end

    assert_mock mock
  end

  def test_dispatches_to_uninsuranced_salary
    employee = build(:employee)
    salary = build(:salary, tax_code: "50", insured_for_labor: 0)
    payroll = build(:payroll, salary: salary, employee: employee)

    mock = MiniTest::Mock.new
    mock.expect(:call, 0, [payroll])

    IncomeTaxService::UninsurancedSalary.stub :call, mock do
      assert IncomeTaxService::Dispatcher.call(payroll)
    end

    assert_mock mock
  end

  def test_dispatches_to_irregular_income
    employee = build(:employee)
    salary = build(:salary, tax_code: "50", insured_for_labor: 11100)
    payroll = build(:payroll, salary: salary, employee: employee)

    mock = MiniTest::Mock.new
    mock.expect(:call, 0, [payroll])

    IncomeTaxService::IrregularIncome.stub :call, mock do
      assert IncomeTaxService::Dispatcher.call(payroll)
    end

    assert_mock mock
  end
end
