# frozen_string_literal: true
require "test_helper"

class CalculatableTest < ActiveSupport::TestCase
  def test_total_income
    CalculationService::TotalIncome.expects(:call).returns(5000)
    assert_equal 5000, DummyObject.new.total_income
  end

  def test_total_deduction
    CalculationService::TotalDeduction.expects(:call).returns(5000)
    assert_equal 5000, DummyObject.new.total_deduction
  end

  def test_vacation_refund
    CalculationService::VacationRefund.expects(:call).returns(5000)
    assert_equal 5000, DummyObject.new.vacation_refund
  end

  def test_leavetime
    CalculationService::Leavetime.expects(:call).returns(5000)
    assert_equal 5000, DummyObject.new.leavetime
  end

  def test_sicktime
    CalculationService::Sicktime.expects(:call).returns(5000)
    assert_equal 5000, DummyObject.new.sicktime
  end

  def test_supplement_premium
    HealthInsuranceService::Dispatcher.expects(:call).returns(5000)
    assert_equal 5000, DummyObject.new.supplement_premium
  end

  def test_income_tax
    IncomeTaxService::Dispatcher.expects(:call).returns(5000)
    assert_equal 5000, DummyObject.new.income_tax
  end

  def test_overtime
    subject = DummyObject.new(
      build(
        :payroll,
        employee: build(:employee),
        salary: build(:salary)
      ) { |payroll| create(:overtime, payroll: payroll) }
    )
    CalculationService::Overtime.expects(:call).at_least_once.returns(1000)
    assert_equal 1000, subject.overtime
  end

  def test_paid_amount_for_regular_income
    subject = prepare_subject(tax_code: 50, insured_for_health: 1, insured_for_labor: 1)
    subject.stubs(:income_before_withholdings).returns(100)
    subject.stubs(:income_tax).returns(1)
    assert_equal 100, subject.paid_amount
  end

  def test_paid_amount_for_parttime_income_uninsured_for_labor
    subject = prepare_subject(tax_code: 50, insured_for_health: 0, insured_for_labor: 0)
    subject.stubs(:income_before_withholdings).returns(100)
    subject.stubs(:income_tax).returns(1)
    assert_equal 100, subject.paid_amount
  end

  def test_paid_amount_for_parttime_income_uninsured_for_health
    subject = prepare_subject(tax_code: 50, insured_for_health: 0, insured_for_labor: 1)
    subject.stubs(:income_before_withholdings).returns(100)
    subject.stubs(:income_tax).returns(1)
    assert_equal 99, subject.paid_amount
  end

  def test_paid_amount_for_professional_services
    subject = prepare_subject(tax_code: "9a", insured_for_health: 0, insured_for_labor: 0)
    subject.stubs(:income_before_withholdings).returns(100)
    subject.stubs(:income_tax).returns(1)
    assert_equal 100, subject.paid_amount
  end

  def test_taxable_income
    subject = DummyObject.new
    subject.stubs(:total_income).returns(100)
    subject.stubs(:basic_deductions).returns(1)
    subject.stubs(:subsidy_income).returns(1)
    subject.stubs(:bonus_income).returns(1)
    assert_equal 97, subject.taxable_income
  end

  def test_bonus_income
    subject = DummyObject.new(build(:payroll, festival_bonus: 50))
    subject.payroll.stubs(:extra_income_of).with(:bonus).returns(100)
    assert_equal 150, subject.bonus_income
  end

  def test_subsidy_income
    subject = DummyObject.new
    subject.payroll.stubs(:extra_income_of).with(:subsidy).returns(100)
    subject.stubs(:overtime).returns(20)
    subject.stubs(:vacation_refund).returns(30)
    assert_equal 150, subject.subsidy_income
  end

  def test_with_excess_income
    subject = DummyObject.new(build(:payroll, salary: build(:salary, insured_for_health: 22000)))
    subject.stubs(:total_income).returns(50000)
    subject.stubs(:total_deduction).returns(4000)
    subject.stubs(:subsidy_income).returns(10000)
    assert_equal 14000, subject.excess_income
  end

  def test_without_excess_income
    subject = DummyObject.new(build(:payroll, salary: build(:salary, insured_for_health: 22000)))
    subject.stubs(:total_income).returns(20000)
    subject.stubs(:total_deduction).returns(0)
    subject.stubs(:subsidy_income).returns(0)
    assert_equal 0, subject.excess_income
  end

  def test_monthly_wage
    subject = DummyObject.new(build(:payroll, salary: build(:salary, monthly_wage: 24000)))
    subject.stubs(:scale_for_cycle).with(subject.payroll.monthly_wage).returns(24000)
    assert_equal 24000, subject.monthly_wage
  end

  def test_total_wage
    subject = DummyObject.new(build(:payroll, parttime_hours: 10, salary: build(:salary, hourly_wage: 200)))
    assert_equal 2000, subject.total_wage
  end

  def test_labor_insurance
    subject = DummyObject.new(build(:payroll, salary: build(:salary, labor_insurance: 233)))
    subject.stubs(:scale_for_30_days).with(subject.payroll.labor_insurance).returns(233)
    assert_equal 233, subject.labor_insurance
  end

  def test_supervisor_allowance
    subject = DummyObject.new(build(:payroll, salary: build(:salary, supervisor_allowance: 5000)))
    subject.stubs(:scale_for_cycle).with(subject.payroll.supervisor_allowance).returns(5000)
    assert_equal 5000, subject.supervisor_allowance
  end

  def test_equipment_subsidy
    subject = DummyObject.new(build(:payroll, salary: build(:salary, equipment_subsidy: 800)))
    subject.stubs(:scale_for_cycle).with(subject.payroll.equipment_subsidy).returns(800)
    assert_equal 800, subject.equipment_subsidy
  end

  class DummyObject
    attr_reader :payroll

    include Calculatable

    def initialize(payroll = FactoryBot.build(:payroll))
      @payroll = payroll
    end
  end

  private

  def prepare_subject(tax_code:, insured_for_health:, insured_for_labor:)
    DummyObject.new(
      build(
        :payroll,
        year: 2018,
        month: 1,
        salary: build(:salary, tax_code: tax_code, insured_for_health: insured_for_health, insured_for_labor: insured_for_labor),
        employee: build(:employee)
      )
    )
  end
end
