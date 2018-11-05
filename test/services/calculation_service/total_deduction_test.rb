# frozen_string_literal: true
require "test_helper"

module CalculationService
  class TotalDeductionTest < ActiveSupport::TestCase
    def test_regular_role
      subject = prepare_subject(role: "regular")
      assert_equal 12334, CalculationService::TotalDeduction.call(subject)
    end

    def test_parttime_role
      subject = prepare_subject(role: "parttime")
      assert_equal 10834, CalculationService::TotalDeduction.call(subject)
    end

    def test_boss_role
      subject = prepare_subject(role: "boss")
      assert_equal 10643, CalculationService::TotalDeduction.call(subject)
    end

    def test_contractor_role
      subject = prepare_subject(role: "contractor")
      assert_equal 11834, CalculationService::TotalDeduction.call(subject)
    end

    def test_vendor_role
      subject = prepare_subject(role: "vendor")
      assert_equal 11834, CalculationService::TotalDeduction.call(subject)
    end

    def test_advisor_role
      subject = prepare_subject(role: "advisor")
      assert_equal 10291, CalculationService::TotalDeduction.call(subject)
    end

    private

    def prepare_subject(role:)
      prepare_stubs
      payroll = build(:payroll, salary: build(:salary, role: role, health_insurance: 310))
      payroll.stubs(:extra_deductions).returns(10000)
      payroll
    end

    def prepare_stubs
      CalculationService::TotalDeduction.any_instance.stubs(:labor_insurance).returns(233)
      CalculationService::TotalDeduction.any_instance.stubs(:supplement_premium).returns(191)
      CalculationService::TotalDeduction.any_instance.stubs(:income_tax).returns(100)
      CalculationService::TotalDeduction.any_instance.stubs(:sicktime).returns(500)
      CalculationService::TotalDeduction.any_instance.stubs(:leavetime).returns(1000)
    end
  end
end
