# frozen_string_literal: true
require "test_helper"

class EmployeeTest < ActiveSupport::TestCase
  def test_role
    assert_equal decorated_subject.role, "正職"
  end

  private

  def decorated_subject
    ActiveDecorator::Decorator.instance.decorate(
      build(:employee) { |employee| create(:salary, role: "regular", employee: employee) }
    )
  end
end
