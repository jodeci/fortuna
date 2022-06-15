# frozen_string_literal: true
require "test_helper"

module StatementService
  class BuilderTest < ActiveSupport::TestCase
    def test_builds_statement
      subject = prepare_subject(tax_code: "50", wage: 20000, insured: 0)
      StatementService::Builder.any_instance.expects(:statement).returns(Statement.new)
      Statement.any_instance.expects(:update).returns(true)
      assert StatementService::Builder.call(subject)
    end

    def test_build_unsplit_statement
      subject = prepare_subject(tax_code: "50", wage: 45000, insured: 45800, split: false)
      params = StatementService::Builder.new(subject).send(:params)
      assert_equal 45000, params[:amount]
      assert_nil params[:splits]
    end

    def test_build_split_statement
      subject = prepare_subject(tax_code: "9a", wage: 45000, insured: 0, split: true)
      params = StatementService::Builder.new(subject).send(:params)
      assert_equal 45000, params[:amount]
      assert_equal [20000, 20000, 5000], params[:splits]
      assert_equal 0, params[:excess_income]
    end

    private

    def prepare_subject(tax_code:, wage:, insured:, split: false)
      employee = build(:employee)
      term = build(:term, start_date: "2018-01-01", employee: employee)
      create(
        :payroll,
        year: 2018,
        month: 1,
        salary: build(
          :salary,
          tax_code: tax_code,
          monthly_wage: wage,
          insured_for_health: insured,
          insured_for_labor: insured,
          split: split,
          term: term
        ),
        employee: employee
      )
    end
  end
end
