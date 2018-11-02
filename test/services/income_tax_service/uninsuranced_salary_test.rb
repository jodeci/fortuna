# frozen_string_literal: true
require "test_helper"

module IncomeTaxService
  class UninsurancedSalaryTest < ActiveSupport::TestCase
    def test_income_tax_over_exemption
      subject = prepare_subject(monthly_wage: 100000)
      assert_equal IncomeTaxService::UninsurancedSalary.call(subject), 5000
    end

    def test_income_tax_under_exemption
      subject = prepare_subject(monthly_wage: 50000)
      assert_equal IncomeTaxService::UninsurancedSalary.call(subject), 0
    end

    private

    def prepare_subject(monthly_wage:)
      build(
        :payroll,
        year: 2018,
        month: 1,
        salary: build(:salary, monthly_wage: monthly_wage),
        employee: build(:employee)
      )
    end
  end
end
