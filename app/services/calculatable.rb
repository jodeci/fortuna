# frozen_string_literal: true
module Calculatable
  include PayrollPeriodCountable

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
    SupplementHealthInsuranceService.call(payroll)
  end

  def income_tax
    CalculationService::IncomeTax.call(payroll)
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
end
