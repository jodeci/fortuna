# frozen_string_literal: true
require "test_helper"

module IncomeTaxService
  class ProfessionalServiceTest < ActiveSupport::TestCase
    def test_income_tax_over_exemption
      subject = prepare_subject(monthly_wage: 30000)
      assert_equal 3000, IncomeTaxService::ProfessionalService.call(subject)
    end

    def test_income_tax_under_exemption
      subject = prepare_subject(monthly_wage: 20000)
      assert_equal 0, IncomeTaxService::ProfessionalService.call(subject)
    end

    private

    def prepare_subject(monthly_wage:)
      build(
        :payroll,
        year: 2018,
        month: 5,
        salary: build(:salary, monthly_wage: monthly_wage),
        employee: build(:employee) { |employee| create(:term, start_date: "2018-05-01", employee: employee) }
      )
    end
  end
end
