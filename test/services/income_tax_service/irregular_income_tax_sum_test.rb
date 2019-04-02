# frozen_string_literal: true
require "test_helper"

module IncomeTaxService
  class IrregularIncomeTaxSumTest < ActiveSupport::TestCase

    def test_for_irregular_tax_sum
      prepare_subject(tax_code: 50, insured_for_labor: 1, insured_for_health: 1)
      prepare_subject(tax_code: 50, insured_for_labor: 1, insured_for_health: 0)
      prepare_subject(tax_code: 50, insured_for_labor: 0, insured_for_health: 0)
      prepare_subject(tax_code: "9a", insured_for_labor: 0, insured_for_health: 0)

      assert_equal 9000, IncomeTaxService::IrregularIncomeTaxSum.call(2019, 3)    
    end

    private

    def prepare_subject(tax_code:, insured_for_labor:, insured_for_health:)   
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
          employee: employee
          ), 
        employee: employee
      )
    end
  end
end