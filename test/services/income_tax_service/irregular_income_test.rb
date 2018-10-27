# frozen_string_literal: true
require "test_helper"

class IrregularIncomeTest < ActiveSupport::TestCase
  def test_income_tax_over_exemption
    subject = prepare_subject(festival_bonus: 50000, extra_amount: 50000)
    assert_equal IncomeTaxService::IrregularIncome.call(subject), 5000
  end

  def test_income_tax_under_exemption
    subject = prepare_subject(extra_amount: 50000)
    assert_equal IncomeTaxService::IrregularIncome.call(subject), 0
  end

  private

  def prepare_subject(festival_bonus: 0, extra_amount: 0)
    build(
      :payroll,
      year: 2018,
      month: 5,
      festival_bonus: festival_bonus,
      salary: build(:salary, monthly_wage: 30000),
      employee: build(:employee)
    ) { |payroll| create(:extra_entry, income_type: :salary, amount: extra_amount, payroll: payroll) }
  end
end
