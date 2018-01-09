# frozen_string_literal: true
class ParttimeEmployeePayrollService < RegularEmployeePayrollService
  private

  def gain
    cleanup(
      base: total_wage,
      commuting_subsidy: salary.commuting_subsidy,
      extra: extra_gain
    )
  end

  def total_wage
    (payroll.parttime_hours * salary.base).round
  end

  def extra_gain
    ExtraEntriesService.new(payroll).gain
  end
end
