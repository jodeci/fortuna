# frozen_string_literal: true
require "test_helper"

module IncomeTaxService
  class InsurancedSalaryTest
    def test_has_insuranced_salary_tax
      assert_equal 3000, IncomeTaxService::InsurancedSalary.call(subject)
    end

    private

    def subject
      build(
        :payroll,
        year: 2018,
        month: 5,
        salary: build(:salary, fixed_income_tax: 3000),
        employee: build(:employee)
      )
    end
  end
end
