# frozen_string_literal: true
require "test_helper"

module IncomeTaxService
  class UninsurancedSalaryTest < ActiveSupport::TestCase
    def test_income_tax_over_exemption
      subject = prepare_subject(monthly_wage: 100000, festival_bonus: 100000, split: false)
      assert_equal 10000, IncomeTaxService::UninsurancedSalary.call(subject)
    end

    def test_income_tax_under_exemption
      subject = prepare_subject(monthly_wage: 50000, festival_bonus: 50000, split: false)
      assert_equal 0, IncomeTaxService::UninsurancedSalary.call(subject)
    end

    def test_income_tax_over_exemption_with_split
      subject = prepare_subject(monthly_wage: 100000, split: true)
      assert_equal 0, IncomeTaxService::UninsurancedSalary.call(subject)
    end

    private

    def prepare_subject(monthly_wage:, festival_bonus: 0, split:)
      employee = build(:employee)
      term = build(:term, start_date: "2018-01-01", employee: employee)
      build(
        :payroll,
        year: 2018,
        month: 1,
        festival_bonus: festival_bonus,
        salary: build(:salary, monthly_wage: monthly_wage, split: split, term: term),
        employee: employee
      )
    end
  end
end
