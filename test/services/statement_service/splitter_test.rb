# frozen_string_literal: true
require "test_helper"

module StatementService
  class SplitterTest < ActiveSupport::TestCase
    def test_no_splits_for_regular_income
      subject = prepare_subject(tax_code: 50, insured_for_health: 800, insured_for_labor: 45800, wage: 40000, fixed_income_tax: 1000)
      assert_nil StatementService::Splitter.call(subject)
    end

    def test_split_for_professional_service
      subject = prepare_subject(tax_code: "9a", insured_for_health: 0, insured_for_labor: 0, wage: 50000, fixed_income_tax: 0)
      assert_equal [20000, 20000, 10000], StatementService::Splitter.call(subject)

      subject = prepare_subject(tax_code: "9a", insured_for_health: 0, insured_for_labor: 0, wage: 20000, fixed_income_tax: 0)
      assert_nil StatementService::Splitter.call(subject)
    end

    def test_split_for_parttime_salary
      subject = prepare_subject(tax_code: 50, insured_for_health: 0, insured_for_labor: 0, wage: 50000, fixed_income_tax: 1000)
      assert_equal [20000, 20000, 9000], StatementService::Splitter.call(subject)

      subject = prepare_subject(tax_code: 50, insured_for_health: 0, insured_for_labor: 0, wage: 22000, fixed_income_tax: 1000)
      assert_nil StatementService::Splitter.call(subject)
    end

    def test_split_for_contractor_salary
      subject = prepare_subject(tax_code: 50, insured_for_health: 0, insured_for_labor: 55000, wage: 50000, fixed_income_tax: 1000)
      assert_equal [20000, 20000, 9000], StatementService::Splitter.call(subject)

      subject = prepare_subject(tax_code: 50, insured_for_health: 0, insured_for_labor: 22000, wage: 20000, fixed_income_tax: 1000)
      assert_nil StatementService::Splitter.call(subject)
    end

    private

    def prepare_subject(tax_code: 50, insured_for_health: 0, insured_for_labor: 0, wage: 0, fixed_income_tax: 0)
      build(
        :payroll,
        year: 2018,
        month: 1,
        salary: build(
          :salary,
          monthly_wage: wage,
          tax_code: tax_code,
          insured_for_health: insured_for_health,
          insured_for_labor: insured_for_labor,
          fixed_income_tax: fixed_income_tax
        ),
        employee: build(:employee) { |employee| create(:term, start_date: "2018-01-01", employee: employee) }
      )
    end
  end
end
