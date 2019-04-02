# frozen_string_literal: true
module SalaryService
  class TaxableIncomeTest < ActiveSupport::TestCase

    def test_taxable_income_for_regular_income
      subject = prepare_subject(tax_code: 50, insured_for_labor: 1, insured_for_health: 1)
      SalaryService::TaxableIncome.any_instance.stubs(:taxable_income).returns(100)
      assert_equal 100, SalaryService::TaxableIncome.call(subject)
    end

    def test_taxable_income_for_parttime_income_uninsured_for_labor
      subject = prepare_subject(tax_code: 50, insured_for_health: 0, insured_for_labor: 0)
      SalaryService::TaxableIncome.any_instance.stubs(:taxable_income).returns(100)
      assert_equal 0, SalaryService::TaxableIncome.call(subject)
    end

    def test_taxable_income_for_parttime_income_uninsured_for_health
      subject = prepare_subject(tax_code: 50, insured_for_health: 0, insured_for_labor: 1)
      SalaryService::TaxableIncome.any_instance.stubs(:taxable_income).returns(100)
      assert_equal 100, SalaryService::TaxableIncome.call(subject)
    end

    def test_taxable_income_for_professional_services
      subject = prepare_subject(tax_code: "9a", insured_for_health: 0, insured_for_labor: 0)
      SalaryService::TaxableIncome.any_instance.stubs(:taxable_income).returns(100)
      assert_equal 0, SalaryService::TaxableIncome.call(subject)
    end

    private
    
    def prepare_subject(tax_code:, insured_for_labor:, insured_for_health:) 
      employee = create(:employee)
      create(
        :payroll, 
        salary: create(
          :salary,
          fixed_income_tax: 100,
          tax_code: tax_code,
          insured_for_health: insured_for_health,
          insured_for_labor: insured_for_labor,
          employee: employee, 
          ), 
        employee: employee
      )
    end
  end
end