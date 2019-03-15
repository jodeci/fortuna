# frozen_string_literal: true
module Calculatable
  include PayrollPeriodCountable

  delegate :extra_income, :health_insurance, to: :payroll

  # 進項的加總
  def total_income
    CalculationService::TotalIncome.call(payroll)
  end

  # 銷項的加總
  def total_deduction
    CalculationService::TotalDeduction.call(payroll)
  end

  # 扣除代扣所得稅、二代健保之前的淨所得（非約聘）
  # 已代扣所得稅的淨所得（約聘）
  def paid_amount
    if payroll.salary.parttime_income_uninsured_for_health? and payroll.salary.insured_for_labor.positive?
      income_before_withholdings_after_tax
    else
      income_before_withholdings
    end
  end

  # 薪資所得包括代扣的勞健費在內
  def taxable_income
    if payroll.salary.parttime_income_uninsured_for_health? and payroll.salary.insured_for_labor.positive?
      taxable_income_before_tax
    else
      regular_taxable_income
    end
  end

  # 獎金
  def bonus_income
    payroll.extra_income_of(:bonus) + payroll.festival_bonus
  end

  # 超出健保投保薪資之收入
  def excess_income
    return 0 unless payroll.insured_for_health.positive?
    base = (total_income - total_deduction - subsidy_income)
    gap = base - payroll.insured_for_health
    gap.positive? ? gap : 0
  end

  # 補助費用（不屬薪資所得）
  def subsidy_income
    overtime + vacation_refund + payroll.extra_income_of(:subsidy)
  end

  def monthly_wage
    scale_for_cycle(payroll.monthly_wage)
  end

  def total_wage
    (payroll.parttime_hours * payroll.hourly_wage).round
  end

  def overtime
    payroll.overtimes.reduce(0) do |sum, overtime|
      sum + CalculationService::Overtime.call(overtime)
    end
  end

  def vacation_refund
    CalculationService::VacationRefund.call(payroll)
  end

  def leavetime
    CalculationService::Leavetime.call(payroll)
  end

  def sicktime
    CalculationService::Sicktime.call(payroll)
  end

  def supplement_premium
    HealthInsuranceService::Dispatcher.call(payroll)
  end

  def income_tax
    IncomeTaxService::Dispatcher.call(payroll)
  end

  def labor_insurance
    scale_for_30_days(payroll.labor_insurance).round
  end

  def equipment_subsidy
    scale_for_cycle(payroll.equipment_subsidy)
  end

  def supervisor_allowance
    scale_for_cycle(payroll.supervisor_allowance)
  end

  private

  def basic_deduction
    leavetime + sicktime + labor_insurance + health_insurance + payroll.extra_deductions
  end

  def income_before_withholdings
    total_income - basic_deduction
  end

  def income_before_withholdings_after_tax
    income_before_withholdings - income_tax
  end

  def regular_taxable_income
    paid_amount + labor_insurance + health_insurance - subsidy_income - bonus_income
  end

  def taxable_income_before_tax
    regular_taxable_income + income_tax
  end
end
