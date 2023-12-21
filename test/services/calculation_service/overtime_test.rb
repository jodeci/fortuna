# frozen_string_literal: true
require "test_helper"

module CalculationService
  class OvertimeTest < ActiveSupport::TestCase
    def test_weekday_1_to_2_hours
      subject = prepare_subject(hours: 1, rate: :weekday)
      assert_equal 223, CalculationService::Overtime.call(subject)
    end

    def test_weekday_3_to_4_hours
      subject = prepare_subject(hours: 3, rate: :weekday)
      assert_equal ((223 * 2) + 279), CalculationService::Overtime.call(subject)
    end

    def test_weekend_1_to_2_hours
      subject = prepare_subject(hours: 1, rate: :weekend)
      assert_equal 223, CalculationService::Overtime.call(subject)
    end

    def test_weekend_3_to_8_hours
      subject = prepare_subject(hours: 3, rate: :weekend)
      assert_equal ((223 * 2) + 279), CalculationService::Overtime.call(subject)
    end

    def test_weekend_9_to_12_hours
      subject = prepare_subject(hours: 10, rate: :weekend)
      assert_equal ((223 * 2) + (279 * 6) + (446 * 4)), CalculationService::Overtime.call(subject)
    end

    def test_holiday_1_to_8_hours
      subject = prepare_subject(hours: 1, rate: :holiday)
      assert_equal (167 * 8), CalculationService::Overtime.call(subject)
    end

    def test_holiday_9_to_10_hours
      subject = prepare_subject(hours: 9, rate: :holiday)
      assert_equal ((167 * 8) + 223), CalculationService::Overtime.call(subject)
    end

    def test_holiday_11_to_12_hours
      subject = prepare_subject(hours: 11, rate: :holiday)
      assert_equal ((167 * 8) + (223 * 2) + 279), CalculationService::Overtime.call(subject)
    end

    def test_offday_1_to_8_hours
      subject = prepare_subject(hours: 1, rate: :offday)
      assert_equal (167 * 8), CalculationService::Overtime.call(subject)
    end

    def test_offday_9_to_12_hours
      subject = prepare_subject(hours: 10, rate: :offday)
      assert_equal (167 * 8 * 2), CalculationService::Overtime.call(subject)
    end

    private

    def prepare_subject(hours:, rate:)
      build(
        :overtime,
        hours: hours,
        rate: rate,
        payroll: build(:payroll, salary: build(:salary, monthly_wage: 40000))
      )
    end
  end
end
