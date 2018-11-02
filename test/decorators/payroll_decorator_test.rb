# frozen_string_literal: true
require "test_helper"

class PayrollDecoratorTest < ActiveSupport::TestCase
  def test_role
    assert_equal decorated_subject.role, "正職"
  end

  def test_payment_period
    assert_equal decorated_subject.payment_period, "2018-09"
  end

  private

  def decorated_subject
    ActiveDecorator::Decorator.instance.decorate(
      build(
        :payroll,
        year: 2018,
        month: 9,
        salary: create(:salary, role: "regular", employee: build(:employee)),
        employee: build(:employee)
      )
    )
  end
end
