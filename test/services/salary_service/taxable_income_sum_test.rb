# frozen_string_literal: true
require "test_helper"
module SalaryService
  class TaxableIncomeSumTest < ActiveSupport::TestCase
    def test_salary_sum  
      subject = prepare_subject(tax_code: 50, insured_for_labor: 1, insured_for_health: 1, fixed_income_tax: 100 )
      subject = prepare_subject(tax_code: 50, insured_for_labor: 1, insured_for_health: 0 , fixed_income_tax: 100)
      subject = prepare_subject(tax_code: 50, insured_for_labor: 1, insured_for_health: 0, fixed_income_tax: 0)
      subject = prepare_subject(tax_code: "9a", insured_for_labor: 1, insured_for_health: 0, fixed_income_tax: 0)
    
      assert_equal 200, SalaryService::TaxableIncomeSum.call(2019,3)
    end

    private
    
    def prepare_subject(tax_code:, insured_for_labor:, insured_for_health:, fixed_income_tax:)
      prepare_stubs 
      employee = create(:employee)
      create(
        :payroll, 
        year: 2019,
        month: 3,
        salary: create(
          :salary,
          tax_code: tax_code,
          insured_for_health: insured_for_health,
          insured_for_labor: insured_for_labor,
          fixed_income_tax: fixed_income_tax,
          employee: employee
          ), 
        employee: employee
      )
    end 

    def prepare_stubs
      SalaryService::TaxableIncome.any_instance.stubs(:taxable_income).returns(100)
    end
  end
end