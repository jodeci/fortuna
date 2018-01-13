# frozen_string_literal: true
module PayrollPeriodCountable
  def adjust_for_incomplete_month(amount)
    amount * period_length / payroll.days_in_cycle
  end

  def adjust_for_incomplete_month_by_30_days(amount)
    amount * period_by_30_days / 30
  end

  def period_length
    return 0 unless on_payroll?
    if payroll.employee.contractor?
      period_by_business_days
    else
      period_by_30_days
    end
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
    (employee_start <= cycle_end) and (default_end_point >= cycle_start)
  end

  def cycle_start
    Date.new(payroll.year, payroll.month, 1)
  end

  def cycle_end
    Date.new(payroll.year, payroll.month, -1)
  end

  def employee_start
    payroll.employee.start_date
  end

  def employee_end
    payroll.employee.end_date
  end

  def default_end_point
    employee_end || cycle_end
  end

  def period_start
    return false unless on_payroll?
    first_month? ? employee_start.day : 1
  end

  def period_end
    return false unless on_payroll?
    final_month? ? period_end_day : 30
  end

  def period_end_day
    if employee_end.day == cycle_end.day
      30
    else
      employee_end.day
    end
  end

  def period_by_30_days
    period_end - period_start + 1
  end

  def period_by_business_days
    d1 = Date.new(payroll.year, payroll.month, period_start)
    d2 = Date.new(payroll.year, payroll.month, default_end_point.day)
    BusinessCalendarService.new(d1, d2).days
  end
end
