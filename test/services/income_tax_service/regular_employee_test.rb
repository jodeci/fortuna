# frozen_string_literal: true
require "test_helper"

module IncomeTaxService
  class RegularEmployeeTest < ActiveSupport::TestCase
    def test_has_insuranced_salary_and_irregular_income
      IncomeTaxService::InsurancedSalary.expects(:call).returns(3000)
      IncomeTaxService::IrregularIncome.expects(:call).returns(5500)
      assert_equal 8500, IncomeTaxService::RegularEmployee.call(subject)
    end

    private

    def subject
      build(
        :payroll,
        year: 2018,
        month: 5,
        salary: build(:salary),
        employee: build(:employee)
      )
    end
  end
end
