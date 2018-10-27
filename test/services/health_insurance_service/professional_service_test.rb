# frozen_string_literal: true
require "test_helper"

class ProfessionalServiceTest < ActiveSupport::TestCase
  def test_premium_over_exemption
    subject = prepare_subject(monthly_wage: 36000)
    assert_equal HealthInsuranceService::ProfessionalService.call(subject), 688
  end

  def test_premium_under_exemption
    subject = prepare_subject(monthly_wage: 20000)
    assert_equal HealthInsuranceService::ProfessionalService.call(subject), 0
  end

  private

  def prepare_subject(monthly_wage:)
    build(:payroll, salary: build(:salary, monthly_wage: monthly_wage), employee: build(:employee))
  end
end
