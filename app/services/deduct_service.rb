# frozen_string_literal: true
class DeductService
  attr_reader :payroll, :salary

  def initialize(payroll, salary)
    @payroll = payroll
    @salary = salary
  end

  def total
    type = payroll.employee.type.gsub(%r{Employee}, "").downcase
    send(type).values.reduce(:+) || 0
  end

  def regular
    {
      勞保費: labor_insurance,
      健保費: health_insurance,
      二代健保: supplement_premium,
      請假扣薪: leavetime + sicktime,
    }.merge(extra_loss)
  end

  def contractor
    {
      勞保費: labor_insurance,
      健保費: health_insurance,
      二代健保: supplement_premium,
      所得稅: income_tax_9a,
      請假扣薪: leavetime,
    }.merge(extra_loss)
  end

  def parttime
    {
      勞保費: labor_insurance,
      健保費: health_insurance,
      二代健保: supplement_premium,
    }.merge(extra_loss)
  end

  private

  # TODO: todo
  def income_tax_9a
    0
  end

  def labor_insurance
    LaborInsuranceService.new(payroll, salary).run
  end

  def health_insurance
    HealthInsuranceService.new(payroll, salary).normal
  end

  def supplement_premium
    HealthInsuranceService.new(payroll, salary).supplement_premium
  end

  def leavetime
    LeavetimeService.new(payroll.leavetime_hours, salary, payroll.days_in_cycle).normal
  end

  def sicktime
    LeavetimeService.new(payroll.sicktime_hours, salary, payroll.days_in_cycle).sick
  end

  def extra_loss
    ExtraEntriesService.new(payroll).loss
  end
end
