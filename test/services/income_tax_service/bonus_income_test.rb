# frozen_string_literal: true
require "test_helper"

module IncomeTaxService
  class BonusIncomeTest < ActiveSupport::TestCase
    def test_bonus_tax_over_exemption
      subject = prepare_subject(festival_bonus: 100000)
      assert_equal 5000, IncomeTaxService::BonusIncome.call(subject)
    end

    def test_bonus_tax_under_exemption
      subject = prepare_subject(festival_bonus: 50000)
      assert_equal 0, IncomeTaxService::BonusIncome.call(subject)
    end

    private

    def prepare_subject(festival_bonus: 0)
      build(
        :payroll,
        year: 2018,
        month: 5,
        festival_bonus: festival_bonus
      )
    end
  end
end
