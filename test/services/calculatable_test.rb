# frozen_string_literal: true
require "test_helper"
require "minitest/mock"
require "mocha/minitest"

class CalculatableTest < ActiveSupport::TestCase
  include Calculatable

  def test_total_income
    mock = MiniTest::Mock.new
    mock.expect(:call, 0, [payroll])
    CalculationService::TotalIncome.stub :call, mock, [payroll] do
      assert total_income
    end
    assert_mock mock
  end

  def test_total_deduction
    mock = MiniTest::Mock.new
    mock.expect(:call, 0, [payroll])
    CalculationService::TotalDeduction.stub :call, mock, [payroll] do
      assert total_deduction
    end
    assert_mock mock
  end

  def test_vacation_refund
    mock = MiniTest::Mock.new
    mock.expect(:call, 0, [payroll])
    CalculationService::VacationRefund.stub :call, mock, [payroll] do
      assert vacation_refund
    end
    assert_mock mock
  end

  def test_leavetime
    mock = MiniTest::Mock.new
    mock.expect(:call, 0, [payroll])
    CalculationService::Leavetime.stub :call, mock, [payroll] do
      assert leavetime
    end
    assert_mock mock
  end

  def test_sicktime
    mock = MiniTest::Mock.new
    mock.expect(:call, 0, [payroll])
    CalculationService::Sicktime.stub :call, mock, [payroll] do
      assert sicktime
    end
    assert_mock mock
  end

  def test_supplement_premium
    mock = MiniTest::Mock.new
    mock.expect(:call, 0, [payroll])
    HealthInsuranceService::Dispatcher.stub :call, mock, [payroll] do
      assert supplement_premium
    end
    assert_mock mock
  end

  def test_income_tax
    mock = MiniTest::Mock.new
    mock.expect(:call, 0, [payroll])
    IncomeTaxService::Dispatcher.stub :call, mock, [payroll] do
      assert income_tax
    end
    assert_mock mock
  end

  def test_overtime
    mock = MiniTest::Mock.new
    mock.expect(:call, 0, [overtime_object])
    CalculationService::Overtime.stub :call, mock, [overtime_object] do
      assert overtime
    end
    assert_mock mock
  end

  def test_income_before_withholdings
    self.stubs(:total_income).returns(100)
    self.stubs(:leavetime).returns(1)
    self.stubs(:sicktime).returns(1)
    payroll.stubs(:extra_deductions).returns(1)
    assert_equal 97, income_before_withholdings
  end

  def test_taxable_income
    self.stubs(:income_before_withholdings).returns(100)
    self.stubs(:subsidy_income).returns(20)
    assert_equal 80, taxable_income
  end

  def test_bonus_income
    payroll.stubs(:extra_income_of).with(:bonus).returns(100)
    payroll.stubs(:festival_bonus).returns(50)
    assert_equal 150, bonus_income
  end

  def test_subsidy_income
    self.stubs(:overtime).returns(20)
    self.stubs(:vacation_refund).returns(30)
    payroll.stubs(:extra_income_of).with(:subsidy).returns(100)
    assert_equal 150, subsidy_income
  end

  def test_with_excess_income
    self.stubs(:total_income).returns(50000)
    self.stubs(:total_deduction).returns(4000)
    self.stubs(:subsidy_income).returns(10000)
    assert_equal 14000, excess_income
  end

  def test_without_excess_income
    self.stubs(:total_income).returns(20000)
    self.stubs(:total_deduction).returns(0)
    self.stubs(:subsidy_income).returns(0)
    assert_equal 0, excess_income
  end

  def test_monthly_wage
    self.stubs(:scale_for_cycle).returns(24000)
    assert_equal 24000, monthly_wage
  end

  def test_total_wage
    payroll.stubs(:hourly_wage).returns(200)
    payroll.stubs(:parttime_hours).returns(10)
    assert_equal 2000, total_wage
  end

  def test_labor_insurance
    self.stubs(:scale_for_30_days).returns(101)
    assert_equal 101, labor_insurance
  end

  def test_supervisor_allowance
    self.stubs(:scale_for_cycle).returns(4000)
    assert_equal 4000, supervisor_allowance
  end

  def test_equipment_subsidy
    self.stubs(:scale_for_cycle).returns(800)
    assert_equal 800, equipment_subsidy
  end

  private

  def payroll
    @payroll ||= build(
      :payroll,
      year: 2018,
      month: 1,
      salary: build(:salary, insured_for_health: 22000),
      employee: build(:employee)
    ) { |payroll| create(:overtime, payroll: payroll) }
  end

  def overtime_object
    @overtime_object ||= payroll.overtimes.first
  end
end
