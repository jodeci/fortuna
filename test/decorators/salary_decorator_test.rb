# frozen_string_literal: true
require "test_helper"

class SalaryDecoratorTest < ActiveSupport::TestCase
  def test_monthly_wage
    subject = decorated_subject(monthly_wage: 50000)
    assert_equal subject.wage_type, "月薪"
    assert_equal subject.wage, 50000
  end

  def test_hourly_wage
    subject = decorated_subject(hourly_wage: 200)
    assert_equal subject.wage_type, "時薪"
    assert_equal subject.wage, 200
  end

  private

  def decorated_subject(monthly_wage: 0, hourly_wage: 0)
    ActiveDecorator::Decorator.instance.decorate(
      build(:salary, monthly_wage: monthly_wage, hourly_wage: hourly_wage)
    )
  end
end
