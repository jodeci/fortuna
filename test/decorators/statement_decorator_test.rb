# frozen_string_literal: true
require "test_helper"

class StatementDecoratorTest < ActiveSupport::TestCase
  def test_declared_income
    subject = decorated_subject(amount: 10000, subsidy: 500, correction: 5)
    assert_equal 9505, subject.declared_income
    assert_equal '<td class="highlight">9,505</td>', subject.declared_income_cell
  end

  def test_paid_amount
    subject = decorated_subject(amount: 10000, subsidy: 500, correction: 5)
    assert_equal 10005, subject.paid_amount
    assert_equal '<td class="highlight">10,005</td>', subject.paid_amount_cell
  end

  private

  def decorated_subject(amount: 0, subsidy: 0, correction: 0)
    ActiveDecorator::Decorator.instance.decorate(
      build(
        :statement,
        amount: amount,
        subsidy_income: subsidy,
        correction: correction,
        payroll: build(:payroll)
      ) { |statement| create(:correction, statement: statement) }
    )
  end
end
