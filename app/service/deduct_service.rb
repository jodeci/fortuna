# frozen_string_literal: true
class DeductService
  attr_reader :payroll, :salary

  def initialize(payroll, salary)
    @payroll = payroll
    @salary = salary
  end

  def run
    {
      leavetime: leavetime + sicktime,
      labor_insurance: labor_insurance,
      health_insurance: health_insurance,
    }.transform_values(&:to_i)
  end

  private

  def labor_insurance
    LaborInsuranceService.new(salary).run
  end

  def health_insurance
    HealthInsuranceService.new(salary).run
  end

  def leavetime
    LeavetimeService.new(payroll.leavetime_hours, salary).normal
  end

  def sicktime
    LeavetimeService.new(payroll.sicktime_hours, salary).sick
  end
end
