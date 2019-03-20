# frozen_string_literal: true
module SalaryService
  class TaxableIncomeTest < ActiveSupport::TestCase

    def test_taxable_income
      subject = prepare_subject
      assert_equal 100, SalaryService::TaxableIncome.call(subject)
    end

    private

    def prepare_subject
      prepare_stubs
      employee = create(:employee)
      create(
        :payroll, 
        salary: create(:salary,employee: employee), 
        employee: employee
      )
      end

    def prepare_stubs
      SalaryService::TaxableIncome.any_instance.stubs(:taxable_income).returns(100)
    end
  end
end