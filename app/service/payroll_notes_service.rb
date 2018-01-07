# frozen_string_literal: true
class PayrollNotesService
  attr_reader :payroll

  def initialize(payroll)
    @payroll = payroll
  end

  def run
    {
      first_month: first_month?,
      final_month: final_month?,
      leavetime: payroll.leavetime_hours,
      sicktime: payroll.sicktime_hours,
      overtime: overtime,
      vacation: payroll.vacation_refund_hours,
    }
  end

  private

  def first_month?
    WorkingDaysService.new(payroll).first_month?
  end

  def final_month?
    WorkingDaysService.new(payroll).final_month?
  end

  def overtime
    payroll.overtimes.map do |ot|
      { hours: ot.hours, date: ot.date.strftime("%Y-%m-%d") }
    end
  end
end
