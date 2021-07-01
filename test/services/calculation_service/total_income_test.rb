# frozen_string_literal: true
require "test_helper"

module CalculationService
  class TotalIncomeTest < ActiveSupport::TestCase
    def test_regular_role
      subject = prepare_subject(role: "regular")
      assert_equal 48080, CalculationService::TotalIncome.call(subject)
    end

    def test_parttime_role
      subject = prepare_subject(role: "parttime")
      assert_equal 28980, CalculationService::TotalIncome.call(subject)
    end

    def test_boss_role
      subject = prepare_subject(role: "boss")
      assert_equal 37980, CalculationService::TotalIncome.call(subject)
    end

    def test_contractor_role
      subject = prepare_subject(role: "contractor")
      assert_equal 42780, CalculationService::TotalIncome.call(subject)
    end

    def test_vendor_role
      subject = prepare_subject(role: "vendor")
      assert_equal 36480, CalculationService::TotalIncome.call(subject)
    end

    def test_advisor_role
      subject = prepare_subject(role: "advisor")
      assert_equal 24480, CalculationService::TotalIncome.call(subject)
    end

    private

    def prepare_subject(role:)
      prepare_stubs
      payroll = build(:payroll, salary: build(:salary, role: role, commuting_subsidy: 3000))
      payroll.stubs(:festival_bonus).returns(1500)
      payroll
    end

    def prepare_stubs
      CalculationService::TotalIncome.any_instance.stubs(:monthly_wage).returns(36000)
      CalculationService::TotalIncome.any_instance.stubs(:total_wage).returns(24000)
      CalculationService::TotalIncome.any_instance.stubs(:extra_income).returns(480)
      CalculationService::TotalIncome.any_instance.stubs(:equipment_subsidy).returns(800)
      CalculationService::TotalIncome.any_instance.stubs(:supervisor_allowance).returns(5000)
      CalculationService::TotalIncome.any_instance.stubs(:commuting_subsidy).returns(300)
      CalculationService::TotalIncome.any_instance.stubs(:overtime).returns(4000)
    end
  end
end
