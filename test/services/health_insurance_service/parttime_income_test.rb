# frozen_string_literal: true
require "test_helper"

module HealthInsuranceService
  class ParttimeIncomeTest < ActiveSupport::TestCase
    def test_premium_over_exemption
      subject = prepare_subject(monthly_wage: 36000, split: false)
      assert_equal 688, HealthInsuranceService::ParttimeIncome.call(subject)
    end

    def test_premium_under_exemption
      subject = prepare_subject(monthly_wage: 22000, split: false)
      assert_equal 0, HealthInsuranceService::ParttimeIncome.call(subject)
    end

    def test_premium_over_exemption_with_split
      subject = prepare_subject(monthly_wage: 36000, split: true)
      assert_equal 0, HealthInsuranceService::ParttimeIncome.call(subject)
    end

    private

    def prepare_subject(monthly_wage:, split:)
      employee = build(:employee)
      term = build(:term, start_date: "2018-03-01", employee: employee)
      build(
        :payroll,
        year: 2018,
        month: 3,
        salary: build(:salary, monthly_wage: monthly_wage, split: split, term: term),
        employee: employee
      )
    end
  end
end
