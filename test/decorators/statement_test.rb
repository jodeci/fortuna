# frozen_string_literal: true
require "test_helper"

class StatementTest < ActiveSupport::TestCase
  def test_declared_income
    subject = decorated_subject(amount: 10000, subsidy: 500, correction: 5)
    assert_equal subject.declared_income, 9505
    assert_equal subject.declared_income_cell, '<td class="highlight">9,505</td>'
  end

  def test_paid_amount
    subject = decorated_subject(amount: 10000, subsidy: 500, correction: 5)
    assert_equal subject.paid_amount, 10005
    assert_equal subject.paid_amount_cell, '<td class="highlight">10,005</td>'
  end

  private

  def decorated_subject(amount: 0, subsidy: 0, correction: 0)
    ActiveDecorator::Decorator.instance.decorate(
      build(
        :statement,
        amount: amount,
        subsidy_income: subsidy,
        payroll: build(:payroll)
      ) { |statement| create(:correction, amount: correction, statement: statement) }
    )
  end
end
