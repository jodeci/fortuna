# frozen_string_literal: true
class HealthInsuranceService
  attr_reader :salary, :employee

  def initialize(salary)
    @salary = salary
    @employee = salary.employee
  end

  # TODO: 健保費計算（家眷）
  def run
    296
  end
end
