# frozen_string_literal: true
require "test_helper"

module HealthInsuranceService
  class BonusIncomeTest < ActiveSupport::TestCase
    # 全年度獎金超過投保金額四倍時徵收，每月結算
    # 計費基準為「當月獎金」和「全年累計獎金與投保金額四倍差距」的最小值
    def test_yearly_premium
      # 全年累計 0, 扣除額 96000
      subject = prepare_subject(month: 1, insured: 24000, bonus: 0)
      assert_equal 0, HealthInsuranceService::BonusIncome.call(subject)

      # 全年累計 100000, 扣除額 96000, 獎投差額 4000, 當月獎金 100000
      # 計費基準為 4000
      subject = prepare_subject(month: 2, insured: 24000, bonus: 100000)
      assert_equal 77, HealthInsuranceService::BonusIncome.call(subject)

      # 全年累計 120000, 扣除額 100800, 獎投差額 19200, 當月獎金 20000
      # 計費基準為 19200
      subject = prepare_subject(month: 6, insured: 25200, bonus: 20000)
      assert_equal 367, HealthInsuranceService::BonusIncome.call(subject)

      # 全年累計 125000, 扣除額 100800, 獎投差額 24200, 當月獎金 5000
      # 計費基準為 5000
      subject = prepare_subject(month: 9, insured: 25200, bonus: 5000)
      assert_equal 96, HealthInsuranceService::BonusIncome.call(subject)
    end

    private

    def employee
      @employee ||= build(:employee) { |employee| create(:term, start_date: "2016-01-01", employee: employee) }
    end

    def prepare_subject(month:, insured:, bonus:)
      build(
        :payroll,
        year: 2016,
        month: month,
        festival_bonus: bonus,
        salary: build(
          :salary,
          insured_for_health: insured,
          insured_for_labor: insured,
          employee: employee,
          term: build(:term)
        ),
        employee: employee
      ) { |payroll| create(:statement, excess_income: bonus, payroll: payroll) }
    end
  end
end
