# frozen_string_literal: true
require "test_helper"
module SalaryService
  class BonusIncomeTest < ActiveSupport::TestCase
    def test_bonus_income_for_regular_income
      subject = prepare_subject(tax_code: 50, insured_for_labor: 1, insured_for_health: 1, fixed_income_tax: 100 )
      SalaryService::BonusIncome.any_instance.stubs(:bonus_income).returns(100)
      assert_equal 100, SalaryService::BonusIncome.call(subject)
    end

    def test_bonus_income_for_parttime_income_uninsured_for_labor
      subject = prepare_subject(tax_code: 50, insured_for_health: 0, insured_for_labor: 0, fixed_income_tax: 100)
      SalaryService::BonusIncome.any_instance.stubs(:bonus_income).returns(100)
      assert_equal 0, SalaryService::BonusIncome.call(subject)
    end

    def test_bonus_income_for_parttime_income_uninsured_for_health
      subject = prepare_subject(tax_code: 50, insured_for_health: 0, insured_for_labor: 1, fixed_income_tax: 100)
      SalaryService::BonusIncome.any_instance.stubs(:bonus_income).returns(100)
      assert_equal 100, SalaryService::BonusIncome.call(subject)
    end

    def test_bonus_income_for_professional_services
      subject = prepare_subject(tax_code: "9a", insured_for_health: 0, insured_for_labor: 0, fixed_income_tax: 100)
      SalaryService::BonusIncome.any_instance.stubs(:bonus_income).returns(100)
      assert_equal 0, SalaryService::BonusIncome.call(subject)
    end

    private
    
    def prepare_subject(tax_code:, insured_for_labor:, insured_for_health:, fixed_income_tax:) 
      employee = create(:employee)
      create(
        :payroll, 
        salary: create(
          :salary,
          fixed_income_tax: 100,
          tax_code: tax_code,
          insured_for_health: insured_for_health,
          insured_for_labor: insured_for_labor,
          fixed_income_tax: fixed_income_tax,
          employee: employee, 
          ), 
        employee: employee
      )
    end
  end
end