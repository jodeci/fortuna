# frozen_string_literal: true
require "test_helper"

module IncomeTaxService
  class IrregularTaxSumTest < ActiveSupport::TestCase

    def test_for_irregular_tax_sum
      subject = prepare_subject(tax_code: 50, insured_for_labor: 1, insured_for_health: 1, fixed_income_tax: 100 )
      subject = prepare_subject(tax_code: 50, insured_for_labor: 1, insured_for_health: 0 , fixed_income_tax: 100)
      subject = prepare_subject(tax_code: 50, insured_for_labor: 1, insured_for_health: 0, fixed_income_tax: 0)
      subject = prepare_subject(tax_code: "9a", insured_for_labor: 1, insured_for_health: 0, fixed_income_tax: 0)

      assert_equal 9000, IncomeTaxService::IrregularTaxSum.call(2019, 3)    
    end

    private

    def prepare_subject(tax_code:, insured_for_labor:, insured_for_health:, fixed_income_tax:)   
      employee = create(:employee)
      create(
        :payroll, 
        year: 2019, 
        month: 3,
        festival_bonus: 90000,
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
  end
end