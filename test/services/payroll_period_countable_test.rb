# frozen_string_literal: true
require "test_helper"

class PayrollPeriodCountableTest < ActiveSupport::TestCase
  def test_first_month_true
    subject = DummyObject.new(year: 2015, month: 5, start_date: "2015-05-13", end_date: "2017-10-20")
    assert subject.first_month?
  end

  def test_first_month_false
    subject = DummyObject.new(year: 2015, month: 6, start_date: "2015-05-13", end_date: "2017-10-20")
    assert_not subject.first_month?
  end

  def test_final_month_true
    subject = DummyObject.new(year: 2017, month: 10, start_date: "2015-05-13", end_date: "2017-10-20")
    assert subject.final_month?
  end

  def test_final_month_false
    subject = DummyObject.new(year: 2017, month: 2, start_date: "2015-05-13", end_date: "2017-10-20")
    assert_not subject.final_month?
  end

  def test_payment_period_in_first_month_feb_day1
    subject = DummyObject.new(
      year: 2015,
      month: 2,
      start_date: "2015-02-01",
      end_date: "2017-10-20",
      effective_date: "2015-02-01"
    )
    assert_equal 30, subject.period_length
  end

  def test_payment_period_in_first_month_feb_midway
    subject = DummyObject.new(
      year: 2015,
      month: 2,
      start_date: "2015-02-20",
      end_date: "2017-10-20",
      effective_date: "2015-02-20"
    )
    assert_equal 9, subject.period_length
  end

  def test_payment_period_in_first_month_30_day1
    subject = DummyObject.new(
      year: 2015,
      month: 4,
      start_date: "2015-04-01",
      end_date: "2017-10-20",
      effective_date: "2015-04-01"
    )
    assert_equal 30, subject.period_length
  end

  def test_payment_period_in_first_month_30_midway
    subject = DummyObject.new(
      year: 2015,
      month: 4,
      start_date: "2015-04-20",
      end_date: "2017-10-20",
      effective_date: "2015-04-20"
    )
    assert_equal 11, subject.period_length
  end

  def test_payment_period_in_first_month_31_day1
    subject = DummyObject.new(
      year: 2015,
      month: 5,
      start_date: "2015-05-01",
      end_date: "2017-10-20",
      effective_date: "2015-05-01"
    )
    assert_equal 30, subject.period_length
  end

  def test_payment_period_in_first_month_31_midway
    subject = DummyObject.new(
      year: 2015,
      month: 5,
      start_date: "2015-05-13",
      end_date: "2017-10-20",
      effective_date: "2015-05-13"
    )
    assert_equal 19, subject.period_length
  end

  def test_employee_on_payroll_in_normal_month
    subject = DummyObject.new(
      year: 2015,
      month: 7,
      start_date: "2015-05-13",
      end_date: "2017-10-20",
      effective_date: "2015-05-13"
    )
    assert_equal 30, subject.period_length
  end

  def test_payment_period_in_final_month_feb_lastday
    subject = DummyObject.new(
      year: 2017,
      month: 2,
      start_date: "2015-05-13",
      end_date: "2017-02-28",
      effective_date: "2015-05-13"
    )
    assert_equal 30, subject.period_length
  end

  def test_payment_period_in_final_month_31_midway
    subject = DummyObject.new(
      year: 2017,
      month: 10,
      start_date: "2015-05-13",
      end_date: "2017-10-20",
      effective_date: "2015-05-13"
    )
    assert_equal 20, subject.period_length
  end

  def test_payment_period_in_final_month_31_lastday
    subject = DummyObject.new(
      year: 2017,
      month: 10,
      start_date: "2015-05-13",
      end_date: "2017-10-31",
      effective_date: "2015-05-13"
    )
    assert_equal 30, subject.period_length
  end

  def test_payment_period_in_final_month_business
    subject = DummyObject.new(
      year: 2018,
      month: 8,
      start_date: "2017-12-18",
      end_date: "2018-8-16",
      effective_date: "2017-12-18",
      cycle: "business"
    )
    assert_equal 12, subject.period_length
  end

  def test_payment_period_before_employement
    subject = DummyObject.new(
      year: 2015,
      month: 4,
      start_date: "2015-05-13",
      end_date: "2017-10-20",
      effective_date: "2015-05-13"
    )
    assert_equal 0, subject.period_length
  end

  def test_payment_period_after_termination
    subject = DummyObject.new(
      year: 2017,
      month: 11,
      start_date: "2015-05-13",
      end_date: "2017-10-20",
      effective_date: "2015-05-13"
    )
    assert_equal 0, subject.period_length
  end

  def test_payment_period_business_cycle_with_termination
    subject = DummyObject.new(
      year: 2017,
      month: 9,
      start_date: "2015-05-13",
      end_date: "2017-10-20",
      effective_date: "2015-05-13",
      cycle: "business"
    )
    assert_equal 22, subject.period_length
  end

  def test_payment_period_30_day_cycle_with_termination
    subject = DummyObject.new(
      year: 2018,
      month: 9,
      start_date: "2018-02-21",
      end_date: "2018-10-15",
      effective_date: "2018-02-21"
    )
    assert_equal 30, subject.period_length
  end

  def test_payment_period_30_days_in_february_ongoing_employee
    subject = DummyObject.new(year: 2016, month: 2, start_date: "2015-05-13", effective_date: "2018-05-13")
    assert_equal 30, subject.period_length
  end

  def test_payment_period_30_days_in_large_month_ongoing_employee
    subject = DummyObject.new(year: 2016, month: 7, start_date: "2015-05-13", effective_date: "2018-05-13")
    assert_equal 30, subject.period_length
  end

  def test_payment_period_30_days_edge_february
    subject = DummyObject.new(
      year: 2016,
      month: 2,
      start_date: "2015-05-13",
      end_date: "2016-02-29",
      effective_date: "2015-05-13"
    )
    assert_equal 30, subject.period_length
  end

  def test_payment_period_30_days_edge_large_month
    subject = DummyObject.new(
      year: 2016,
      month: 7,
      start_date: "2015-05-13",
      end_date: "2016-07-31",
      effective_date: "2015-05-13"
    )
    assert_equal 30, subject.period_length
  end

  def test_payment_period_business_cycle
    subject = DummyObject.new(
      year: 2018,
      month: 2,
      start_date: "2018-02-21",
      effective_date: "2018-02-21",
      cycle: "business"
    )
    assert_equal 5, subject.period_length
  end

  def test_days_in_cycle_for_regular_employee
    subject = DummyObject.new(year: 2018, month: 2)
    assert_equal 30, subject.days_in_cycle
  end

  def test_days_in_cycle_for_business_cycle
    subject = DummyObject.new(year: 2018, month: 2, cycle: "business")
    BusinessCalendarDaysService.expects(:call).returns(15)
    assert_equal 15, subject.days_in_cycle
  end

  def test_scale_for_cycle
    subject = DummyObject.new
    subject.expects(:period_length).returns(15)
    subject.expects(:days_in_cycle).returns(20)
    assert_equal 7500, subject.scale_for_cycle(10000)
  end

  def test_scale_for_30_days
    subject = DummyObject.new
    subject.expects(:period_by_30_days).returns(15)
    assert_equal 5000, subject.scale_for_30_days(10000)
  end

  class DummyObject
    attr_reader :payroll, :salary, :options

    include PayrollPeriodCountable

    def initialize(**options)
      @options = options
      @payroll = prepare_payroll
      @salary = @payroll.salary
    end

    private

    def prepare_employee
      FactoryBot.build(:employee)
    end

    def prepare_term
      FactoryBot.build(
        :term,
        start_date: options.fetch(:start_date, nil),
        end_date: options.fetch(:end_date, nil),
        employee: prepare_employee
      )
    end

    def prepare_payroll
      FactoryBot.build(
        :payroll,
        year: options.fetch(:year, nil),
        month: options.fetch(:month, nil),
        employee: prepare_employee,
        salary: prepare_salary
      )
    end

    def prepare_salary
      FactoryBot.build(
        :salary,
        effective_date: options.fetch(:effective_date, nil),
        cycle: options.fetch(:cycle, "normal"),
        term: prepare_term
      )
    end
  end
end
