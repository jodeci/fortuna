# frozen_string_literal: true
require "test_helper"

class EmployeeDecoratorTest < ActiveSupport::TestCase
  def test_role
    assert_equal "正職", decorated_subject.role
  end

  private

  def decorated_subject
    ActiveDecorator::Decorator.instance.decorate(
      build(:employee) { |employee| create(:salary, role: "regular", employee: employee, term: build(:term)) }
    )
  end
end
