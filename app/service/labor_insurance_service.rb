# frozen_string_literal: true
class LaborInsuranceService
  attr_reader :salary, :employee

  def initialize(salary)
    @salary = salary
    @employee = salary.employee
  end

  # TODO: 勞保費計算
  def run
    441
  end
end
