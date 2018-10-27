# frozen_string_literal: true
require "test_helper"

class ProfessionalServiceTest < ActiveSupport::TestCase
  def test_income_tax_over_exemption
    subject = prepare_subject(monthly_wage: 30000)
    assert_equal IncomeTaxService::ProfessionalService.call(subject), 3000
  end

  def test_income_tax_under_exemption
    subject = prepare_subject(monthly_wage: 20000)
    assert_equal IncomeTaxService::ProfessionalService.call(subject), 0
  end

  private

  def prepare_subject(monthly_wage:)
    build(
      :payroll,
      year: 2018,
      month: 5,
      salary: build(:salary, monthly_wage: monthly_wage),
      employee: build(:employee)
    )
  end
end
