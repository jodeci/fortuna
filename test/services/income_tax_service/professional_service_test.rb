# frozen_string_literal: true
require "test_helper"

module IncomeTaxService
  class ProfessionalServiceTest < ActiveSupport::TestCase
    def test_income_tax_over_exemption
      subject = prepare_subject(monthly_wage: 30000, split: false)
      assert_equal 3000, IncomeTaxService::ProfessionalService.call(subject)
    end

    def test_income_tax_under_exemption
      subject = prepare_subject(monthly_wage: 20000, split: false)
      assert_equal 0, IncomeTaxService::ProfessionalService.call(subject)
    end

    def test_income_tax_over_exemption_with_split
      subject = prepare_subject(monthly_wage: 30000, split: true)
      assert_equal 0, IncomeTaxService::ProfessionalService.call(subject)
    end

    private

    def prepare_subject(monthly_wage:, split:)
      employee = build(:employee)
      term = build(:term, start_date: "2018-05-01", employee: employee)
      build(
        :payroll,
        year: 2018,
        month: 5,
        salary: build(:salary, monthly_wage: monthly_wage, split: split, term: term),
        employee: employee
      )
    end
  end
end
