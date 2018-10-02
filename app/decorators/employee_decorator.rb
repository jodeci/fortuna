# frozen_string_literal: true
module EmployeeDecorator
  def role
    salaries.ordered.first.given_role
  end
end
