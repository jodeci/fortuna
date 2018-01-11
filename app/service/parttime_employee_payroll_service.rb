# frozen_string_literal: true
class ParttimeEmployeePayrollService < RegularEmployeePayrollService
  private

  def gain
    cleanup({
      薪資: total_wage,
      交通津貼: salary.commuting_subsidy,
    }.merge(extra_gain))
  end

  def total_wage
    (payroll.parttime_hours * salary.base).round
  end

  def extra_gain
    ExtraEntriesService.new(payroll).gain
  end
end
