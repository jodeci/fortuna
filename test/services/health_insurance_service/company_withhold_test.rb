# frozen_string_literal: true
require "test_helper"

module HealthInsuranceService
  class CompanyWithholdTest < ActiveSupport::TestCase
    def test_premium_62
      prepare_employee(excess: 20000, insured: 24000)
      prepare_employee(excess: 150000, insured: 36000)
      assert_equal 115, HealthInsuranceService::CompanyWithhold.call(2016, 1, 62)
    end

    # TODO
    def test_premium_65
    end

    private

    def prepare_employee(insured:, excess:)
      employee = build(:employee)
      build(
        :payroll,
        year: 2016,
        month: 1,
        salary: build(:salary, insured_for_health: insured, tax_code: "50", employee: employee),
        employee: employee
      ) { |payroll| create(:statement, excess_income: excess, payroll: payroll) }
    end
  end
end
