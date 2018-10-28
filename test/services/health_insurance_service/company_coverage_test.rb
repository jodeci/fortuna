# frozen_string_literal: true
require "test_helper"

class CompanyCoverageTest < ActiveSupport::TestCase
  def test_premium
    prepare_owner(amount: 100000)
    prepare_employee(excess: 6000)
    prepare_employee(excess: 14000)
    prepare_employee(excess: 0)
    assert_equal HealthInsuranceService::CompanyCoverage.call(2016, 1), 2292
  end

  private

  def prepare_employee(excess:)
    employee = build(:employee)
    build(
      :payroll,
      year: 2016,
      month: 1,
      salary: build(:salary, tax_code: "50", employee: employee),
      employee: employee
    ) { |payroll| create(:statement, excess_income: excess, payroll: payroll) }
  end

  def prepare_owner(amount:)
    owner = build(:employee, owner: true)
    build(
      :payroll,
      year: 2016,
      month: 1,
      salary: build(:salary, employee: owner),
      employee: owner
    ) { |payroll| create(:statement, amount: amount, payroll: payroll) }
  end
end
