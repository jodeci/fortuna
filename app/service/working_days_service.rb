# frozen_string_literal: true
class WorkingDaysService
  attr_reader :cycle_start, :cycle_end, :employee_start, :employee_end

  def initialize(payroll)
    @cycle_start = Date.new(payroll.year, payroll.month, 1)
    @cycle_end = Date.new(payroll.year, payroll.month, -1)
    @employee_start = payroll.employee.start_date
    @employee_end = payroll.employee.end_date
  end

  def run
    return 0 unless on_payroll?
    period_end - period_start + 1
  end

  def on_payroll?
    return false unless employee_start
    (employee_start <= cycle_end) and (default_end_point >= cycle_start)
  end

  private

  def default_end_point
    employee_end || cycle_end
  end

  def period_start
    return false unless on_payroll?
    first_month? ? employee_start.day : 1
  end

  def period_end
    return false unless on_payroll?
    final_month? ? employee_end.day : 30
  end

  def first_month?
    return false unless employee_start
    employee_start.between? cycle_start, cycle_end
  end

  def final_month?
    return false unless employee_end
    employee_end.between? cycle_start, cycle_end
  end
end
