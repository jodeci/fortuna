# frozen_string_literal: true
class PayrollService
  attr_reader :payroll, :salary

  def initialize(payroll)
    @payroll = payroll
    @salary = payroll.employee.recent_salary
  end

  def run
    finalize(
      meta: meta,
      monthly_based_income: monthly_based_income,
      fixed_amount_income: fixed_amount_income,
      deductions: deductions
    )
  end

  private

  def meta
    {
      name: payroll.employee.name,
      onboard: payroll.employee.start_date.strftime("%Y-%m-%d"),
      period: payment_period,
      notes: {
        leavetime: payroll.leavetime_hours,
        overtime: payroll.overtime_hours,
        # vacation: payroll.vacation_refund_hours,
      },
    }
  end

  def deductions
    {
      leavetime: leavetime,
      labor_insurance: labor_insurance,
      health_insurance: health_insurance,
    }
  end

  def monthly_based_income
    MonthlyBasedIncomeService.new(salary, working_days).run
  end

  def fixed_amount_income
    FixedAmountIncomeService.new(payroll).run
  end

  def working_days
    WorkingDaysService.new(payroll).run
  end

  def leavetime
    LeavetimeService.new(payroll.leavetime_hours, salary).run
  end

  def finalize(hash)
    i = sum(hash[:monthly_based_income]) + sum(hash[:fixed_amount_income])
    d = sum(hash[:deductions])
    hash[:total] = {
      income: i,
      deduction: d,
      total: i - d,
    }
    hash
  end

  def sum(hash_key)
    hash_key.values.reduce(:+)
  end

  def labor_insurance
    # TODO: 勞保計算
    441
  end

  def health_insurance
    # TODO: 健保計算（家眷）
    296
  end

  def bonus
    # TODO: 獎金需要能處理多筆和自訂項目
  end

  def payment_period
    "#{payroll.year} 年 #{payroll.month} 月"
  end
end
