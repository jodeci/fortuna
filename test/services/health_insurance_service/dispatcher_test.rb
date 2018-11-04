# frozen_string_literal: true
require "test_helper"

module HealthInsuranceService
  class DispatcherTest < ActiveSupport::TestCase
    def test_bypass_when_business
      subject = prepare_subject(tax_code: nil, insured: 0, b2b: true)
      assert_equal 0, HealthInsuranceService::Dispatcher.call(subject)
    end

    def test_dispatches_to_professional_service
      subject = prepare_subject(tax_code: "9a", insured: 0, b2b: false)
      HealthInsuranceService::ProfessionalService.expects(:call).returns(true)
      assert HealthInsuranceService::Dispatcher.call(subject)
    end

    def test_dispatches_to_parttime_income
      subject = prepare_subject(tax_code: 50, insured: 0, b2b: false)
      HealthInsuranceService::ParttimeIncome.expects(:call).returns(true)
      assert HealthInsuranceService::Dispatcher.call(subject)
    end

    def test_dispatches_to_bonus_income
      subject = prepare_subject(tax_code: 50, insured: 22000, b2b: false)
      HealthInsuranceService::BonusIncome.expects(:call).returns(true)
      assert HealthInsuranceService::Dispatcher.call(subject)
    end

    private

    def prepare_subject(tax_code:, insured:, b2b:)
      build(
        :payroll,
        salary: build(:salary, tax_code: tax_code, insured_for_health: insured),
        employee: build(:employee, b2b: b2b)
      )
    end
  end
end
