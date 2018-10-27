# frozen_string_literal: true
require "test_helper"
require "minitest/mock"

class SupplementPremiumDispatcherTest < ActiveSupport::TestCase
  def test_bypass_when_business
    subject = prepare_subject(tax_code: nil, insured_for_health: 0, b2b: true)
    assert_equal HealthInsuranceService::SupplementPremiumDispatcher.call(subject), 0
  end

  def test_dispatches_to_professional_service
    subject = prepare_subject(tax_code: "9a", insured_for_health: 0, b2b: false)
    mock = MiniTest::Mock.new
    mock.expect(:call, 0, [subject])

    HealthInsuranceService::ProfessionalService.stub :call, mock do
      assert HealthInsuranceService::SupplementPremiumDispatcher.call(subject)
    end

    assert_mock mock
  end

  def test_dispatches_to_parttime_income
    subject = prepare_subject(tax_code: 50, insured_for_health: 0, b2b: false)
    mock = MiniTest::Mock.new
    mock.expect(:call, 0, [subject])

    HealthInsuranceService::ParttimeIncome.stub :call, mock do
      assert HealthInsuranceService::SupplementPremiumDispatcher.call(subject)
    end

    assert_mock mock
  end

  def test_dispatches_to_bonus_income
    subject = prepare_subject(tax_code: 50, insured_for_health: 22000, b2b: false)
    mock = MiniTest::Mock.new
    mock.expect(:call, 0, [subject])

    HealthInsuranceService::BonusIncome.stub :call, mock do
      assert HealthInsuranceService::SupplementPremiumDispatcher.call(subject)
    end

    assert_mock mock
  end

  private

  def prepare_subject(tax_code:, insured_for_health:, b2b:)
    build(
      :payroll,
      salary: build(:salary, tax_code: tax_code, insured_for_health: insured_for_health),
      employee: build(:employee, b2b: b2b)
    )
  end
end
