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
      gain: gain,
      loss: loss,
      notes: notes
    )
  end

  private

  def meta
    {
      name: payroll.employee.name,
      onboard: payroll.employee.start_date.strftime("%Y-%m-%d"),
      period: payment_period,
    }
  end

  def notes
    {
      leavetime: payroll.leavetime_hours,
      sicktime: payroll.sicktime_hours,
      overtime: overtime,
      vacation: payroll.vacation_refund_hours,
    }
  end

  def gain
    monthly_based_income.merge(fixed_amount_income).transform_values(&:to_i)
  end

  def loss
    {
      leavetime: leavetime + sicktime,
      labor_insurance: labor_insurance,
      health_insurance: health_insurance,
    }.transform_values(&:to_i)
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
    LeavetimeService.new(payroll.leavetime_hours, salary).normal
  end

  def sicktime
    LeavetimeService.new(payroll.sicktime_hours, salary).sick
  end

  def overtime
    payroll.overtimes.map do |ot|
      { hours: ot.hours, date: ot.date.strftime("%Y-%m-%d") }
    end
  end

  def finalize(hash)
    hash[:meta][:gain] = sum(hash[:gain])
    hash[:meta][:loss] = sum(hash[:loss])
    hash[:meta][:total] = hash[:meta][:gain] - hash[:meta][:loss]
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
    "#{payroll.year}-#{sprintf('%02d', payroll.month)}"
  end
end
