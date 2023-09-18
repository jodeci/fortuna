# frozen_string_literal: true
require "test_helper"

module HealthInsuranceService
  class CompanyCoverageTest < ActiveSupport::TestCase
    def test_premium
      prepare_employee(excess: 100000, owner: true)
      prepare_employee(excess: 6000)
      prepare_employee(excess: 14000)
      prepare_employee(excess: 0)
      assert_equal 2292, HealthInsuranceService::CompanyCoverage.call(2016, 1)
    end

    private

    def prepare_employee(excess:, owner: false)
      employee = build(:employee, owner: owner)
      build(
        :payroll,
        year: 2016,
        month: 1,
        salary: build(:salary, tax_code: "50", employee: employee, term: build(:term)),
        employee: employee
      ) { |payroll| create(:statement, excess_income: excess, payroll: payroll) }
    end
  end
end
