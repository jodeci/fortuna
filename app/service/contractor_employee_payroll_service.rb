# frozen_string_literal: true
class ContractorEmployeePayrollService < RegularEmployeePayrollService
  private

  def gain
    {
      base: salary.base,
      extra: extra_gain,
    }
  end

  def extra_gain
    ExtraEntriesService.new(payroll).gain
  end
end
