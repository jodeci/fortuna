# frozen_string_literal: true
require "test_helper"

class SalaryDecoratorTest < ActiveSupport::TestCase
  def test_monthly_wage
    subject = decorated_subject(monthly_wage: 50000)
    assert_equal "月薪", subject.wage_type
    assert_equal 50000, subject.wage
  end

  def test_hourly_wage
    subject = decorated_subject(hourly_wage: 200)
    assert_equal "時薪", subject.wage_type
    assert_equal 200, subject.wage
  end

  private

  def decorated_subject(monthly_wage: 0, hourly_wage: 0)
    ActiveDecorator::Decorator.instance.decorate(
      build(:salary, monthly_wage: monthly_wage, hourly_wage: hourly_wage)
    )
  end
end
