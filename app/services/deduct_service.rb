# frozen_string_literal: true
class DeductService
  include PayrollPeriodCountable

  attr_reader :payroll, :salary

  def initialize(payroll)
    @payroll = payroll
    @salary = payroll.salary
  end

  def total
    send(salary.role).values.reduce(:+) || 0
  end

  def before_withholdings
    leavetime + sicktime + extra_loss.values.reduce(:+).to_i
  end

  private

  def boss
    {
      勞保費: labor_insurance,
      健保費: health_insurance,
      二代健保: supplement_premium,
      所得稅: income_tax,
    }.merge(extra_loss)
  end

  def regular
    {
      勞保費: labor_insurance,
      健保費: health_insurance,
      二代健保: supplement_premium,
      所得稅: income_tax,
      請假扣薪: leavetime + sicktime,
    }.merge(extra_loss)
  end

  def contractor
    {
      勞保費: labor_insurance,
      健保費: health_insurance,
      二代健保: supplement_premium,
      所得稅: income_tax,
      請假扣薪: leavetime,
    }.merge(extra_loss)
  end

  def parttime
    {
      勞保費: labor_insurance,
      健保費: health_insurance,
      二代健保: supplement_premium,
      所得稅: income_tax,
    }.merge(extra_loss)
  end

  def advisor
    {
      二代健保: supplement_premium,
      所得稅: income_tax,
    }.merge(extra_loss)
  end

  def income_tax
    TaxService.call(payroll)
  end

  def labor_insurance
    scale_for_30_days(salary.labor_insurance).round
  end

  def health_insurance
    salary.health_insurance
  end

  def supplement_premium
    SupplementHealthInsuranceService.call(payroll)
  end

  def leavetime
    CalculationService::Leavetime.call(payroll)
  end

  def sicktime
    CalculationService::Sicktime.call(payroll)
  end

  def extra_loss
    ExtraDeductService.call(payroll)
  end
end
