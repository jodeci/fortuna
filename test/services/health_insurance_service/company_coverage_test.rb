# frozen_string_literal: true
require "test_helper"

class CompanyCoverageTest < ActiveSupport::TestCase
  def test_premium
    prepare_owner(amount: 100000)
    prepare_employee(amount: 30000, insured: 24000)
    prepare_employee(amount: 50000, insured: 36000)
    assert_equal HealthInsuranceService::CompanyCoverage.call(2016, 1), 2292
  end

  private

  def prepare_employee(insured:, amount:)
    employee = build(:employee)
    build(
      :payroll,
      year: 2016,
      month: 1,
      salary: build(:salary, insured_for_health: insured, tax_code: "50", employee: employee),
      employee: employee
    ) { |payroll| create(:statement, amount: amount, payroll: payroll) }
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
