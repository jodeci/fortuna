# frozen_string_literal: true
require "test_helper"

module HealthInsuranceService
  class ParttimeIncomeTest < ActiveSupport::TestCase
    def test_premium_over_exemption
      subject = prepare_subject(monthly_wage: 36000)
      assert_equal HealthInsuranceService::ParttimeIncome.call(subject), 688
    end

    def test_premium_under_exemption
      subject = prepare_subject(monthly_wage: 22000)
      assert_equal HealthInsuranceService::ParttimeIncome.call(subject), 0
    end

    private

    def prepare_subject(monthly_wage:)
      build(
        :payroll,
        year: 2018,
        month: 3,
        salary: build(:salary, monthly_wage: monthly_wage),
        employee: build(:employee)
      )
    end
  end
end
