# frozen_string_literal: true
require "test_helper"

class UninsurancedSalaryTest < ActiveSupport::TestCase
  def income_tax_over_exemption
    subject = prepare_subject(monthly_wage: 30000)
    assert_equal IncomeTaxService::UninsuredSalary.call(subject), 1500
  end

  def income_tax_under_exemption
    subject = prepare_subject(monthly_wage: 20000)
    assert_equal IncomeTaxService::UninsuredSalary.call(subject), 0
  end

  private

  def prepare_subject(monthly_wage:)
    build(:payroll, salary: build(:salary, monthly_wage: monthly_wage), employee: build(:employee))
  end
end
