# frozen_string_literal: true
require "test_helper"

module StatementService
  class SplitterTest < ActiveSupport::TestCase
    def test_no_splits_for_regular_income
      subject = prepare_subject(tax_code: 50, insured: 45800, wage: 40000)
      assert_nil StatementService::Splitter.call(subject)
    end

    def test_split_for_professional_service
      subject = prepare_subject(tax_code: "9a", insured: 0, wage: 50000)
      assert_equal [20000, 20000, 10000], StatementService::Splitter.call(subject)

      subject = prepare_subject(tax_code: "9a", insured: 0, wage: 20000)
      assert_nil StatementService::Splitter.call(subject)
    end

    def test_split_for_parttime_salary
      subject = prepare_subject(tax_code: 50, insured: 0, wage: 50000)
      assert_equal [20000, 20000, 10000], StatementService::Splitter.call(subject)

      subject = prepare_subject(tax_code: 50, insured: 0, wage: 22000)
      assert_nil StatementService::Splitter.call(subject)
    end

    private

    def prepare_subject(tax_code: 50, insured: 0, wage:)
      build(
        :payroll,
        year: 2018,
        month: 1,
        salary: build(
          :salary,
          monthly_wage: wage,
          tax_code: tax_code,
          insured_for_health: insured,
          insured_for_labor: insured
        ),
        employee: build(:employee) { |employee| create(:term, start_date: "2018-01-01", employee: employee) }
      )
    end
  end
end
