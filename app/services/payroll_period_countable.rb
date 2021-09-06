# frozen_string_literal: true
module PayrollPeriodCountable
  def scale_for_cycle(amount)
    amount * period_length / days_in_cycle
  end

  def scale_for_30_days(amount)
    amount * period_by_30_days / 30
  end

  def period_length
    return 0 unless on_payroll?
    if salary.business_calendar?
      period_by_business_days
    else
      period_by_30_days
    end
  end

  def days_in_cycle
    salary.business_calendar? ? BusinessCalendarDaysService.call(cycle_start, cycle_end) : 30
  end

  def first_month?
    return false unless employee_start
    employee_start.between? cycle_start, cycle_end
  end

  def final_month?
    return false unless employee_end
    employee_end.between? cycle_start, cycle_end
  end

  private

  def on_payroll?
    return false unless employee_start
    (employee_start <= cycle_end) && (default_end_point >= cycle_start)
  end

  def cycle_start
    Date.new(payroll.year, payroll.month, 1)
  end

  def cycle_end
    Date.new(payroll.year, payroll.month, -1)
  end

  def employee_start
    salary.term.start_date
  end

  def employee_end
    salary.term.end_date
  end

  def default_end_point
    if employee_end && (employee_end < cycle_end)
      employee_end
    else
      cycle_end
    end
  end

  def period_start
    first_month? ? employee_start.day : 1
  end

  def period_by_30_days
    if first_month?
      period_start_day
    elsif final_month?
      period_end_day
    else
      30
    end
  end

  def period_start_day
    if employee_start.day == 1
      30
    else
      employee_start.end_of_month.day - employee_start.day + 1
    end
  end

  def period_end_day
    if employee_end.day == cycle_end.day
      30
    else
      employee_end.day
    end
  end

  def period_by_business_days
    start_date = Date.new(payroll.year, payroll.month, period_start)
    end_date = Date.new(payroll.year, payroll.month, default_end_point.day)
    BusinessCalendarDaysService.call(start_date, end_date)
  end
end
