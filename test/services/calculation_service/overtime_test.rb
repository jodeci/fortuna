# frozen_string_literal: true
require "test_helper"

module CalculationService
  class OvertimeTest < ActiveSupport::TestCase
    def test_weekday_initial_rate
      subject = prepare_subject(hours: 1, rate: :weekday)
      assert_equal 200, CalculationService::Overtime.call(subject)
    end

    def test_weekday_additional_rate
      subject = prepare_subject(hours: 3, rate: :weekday)
      assert_equal ((200 * 2) + 250), CalculationService::Overtime.call(subject)
    end

    def test_weekend_initial_rate
      subject = prepare_subject(hours: 1, rate: :weekend)
      assert_equal 200, CalculationService::Overtime.call(subject)
    end

    def test_weekend_additional_rate
      subject = prepare_subject(hours: 3, rate: :weekend)
      assert_equal ((200 * 2) + 250), CalculationService::Overtime.call(subject)
    end

    def test_weekend_final_rate
      subject = prepare_subject(hours: 10, rate: :weekend)
      assert_equal ((200 * 2) + (250 * 6) + (400 * 2)), CalculationService::Overtime.call(subject)
    end

    def test_holiday_rate
      subject = prepare_subject(hours: 1, rate: :holiday)
      assert_equal (150 * 8 * 2), CalculationService::Overtime.call(subject)
    end

    private

    def prepare_subject(hours:, rate:)
      build(
        :overtime,
        hours: hours,
        rate: rate,
        payroll: build(:payroll, salary: build(:salary, monthly_wage: 36000))
      )
    end
  end
end
