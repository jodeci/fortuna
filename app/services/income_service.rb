# frozen_string_literal: true
class IncomeService
  include PayrollPeriodCountable

  attr_reader :payroll, :salary

  def initialize(payroll, salary)
    @payroll = payroll
    @salary = salary
  end

  def regular
    {
      本薪: scale_for_cycle(base_salary),
      伙食費: scale_for_cycle(taxfree_lunch),
      設備津貼: scale_for_cycle(salary.equipment_subsidy),
      主管加給: scale_for_cycle(salary.supervisor_allowance),
      加班費: overtime.to_i,
      特休折現: vacation_refund.to_i,
    }.merge(extra_gain)
  end

  def contractor
    { "#{salary_label}": scale_for_cycle(actual_salary) }.merge(extra_gain)
  end

  def parttime
    {
      薪資: total_wage,
      交通津貼: salary.commuting_subsidy,
    }.merge(extra_gain)
  end

  def total
    send(payroll.salary.role).values.reduce(:+) || 0
  end

  private

  def salary_label
    salary.professional_service? ? "開發費" : "薪資"
  end

  def actual_salary
    salary.monthly_wage
  end

  def base_salary
    salary.monthly_wage - taxfree_lunch
  end

  def taxfree_lunch
    payroll.year >= 2015 ? 2400 : 1800
  end

  def total_wage
    (payroll.parttime_hours * salary.hourly_wage).round
  end

  def overtime
    payroll.overtimes.map do |overtime|
      OvertimeService.new(overtime.hours, salary, days_in_cycle).send(overtime.rate)
    end.reduce(:+)
  end

  def vacation_refund
    OvertimeService.new(payroll.vacation_refund_hours, salary, days_in_cycle).basic
  end

  def extra_gain
    ExtraEntriesService.new(payroll).gain
  end
end
