# frozen_string_literal: true
class ContractorEmployeePayrollService < RegularEmployeePayrollService
  include PayrollPeriodCountable

  private

  def gain
    {
      base: base_salary,
      extra: extra_gain,
    }
  end

  def extra_gain
    ExtraEntriesService.new(payroll).gain
  end

  def base_salary
    adjust_for_incomplete_month(salary.base)
  end
end
