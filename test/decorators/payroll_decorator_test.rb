# frozen_string_literal: true
require "test_helper"

class PayrollDecoratorTest < ActiveSupport::TestCase
  def test_role
    assert_equal "正職", decorated_subject.role
  end

  def test_payment_period
    assert_equal "2018-09", decorated_subject.payment_period
  end

  private

  def decorated_subject
    ActiveDecorator::Decorator.instance.decorate(
      build(
        :payroll,
        year: 2018,
        month: 9,
        salary: create(:salary, role: "regular", employee: build(:employee), term: build(:term)),
        employee: build(:employee)
      )
    )
  end
end
