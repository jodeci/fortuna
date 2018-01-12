# frozen_string_literal: true
class ContractorEmployeePayrollService < RegularEmployeePayrollService
  include PayrollPeriodCountable

  private

  def gain
    { 薪資: base_salary }.merge(extra_gain)
  end

  def base_salary
    adjust_for_incomplete_month(salary.base)
  end

  def extra_gain
    ExtraEntriesService.new(payroll).gain
  end

  def extra_loss
    ExtraEntriesService.new(payroll).loss
  end
end
