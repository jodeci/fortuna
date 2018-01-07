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
      loss: loss
    )
  end

  private

  def meta
    {
      name: payroll.employee.name,
      onboard: payroll.employee.start_date.strftime("%Y-%m-%d"),
      leave: payroll.employee.end_date&.strftime("%Y-%m-%d"),
      period: payment_period,
      notes: notes,
    }
  end

  def gain
    cleanup(IncomeService.new(payroll).run)
  end

  def loss
    cleanup(DeductService.new(payroll).run)
  end

  def notes
    PayrollNotesService.new(payroll).run
  end

  def cleanup(hash)
    hash.delete_if { |_, v| v.zero? unless v.is_a? Hash }
  end

  def finalize(hash)
    hash[:meta][:gain] = sum(hash[:gain])
    hash[:meta][:loss] = sum(hash[:loss])
    hash[:meta][:total] = hash[:meta][:gain] - hash[:meta][:loss]
    hash
  end

  def sum(hash, i = 0)
    hash.each_value do |value|
      if value.is_a?(Hash)
        i = sum(value, i)
      else
        i += value
      end
    end
    i
  end

  def payment_period
    "#{payroll.year}-#{sprintf('%02d', payroll.month)}"
  end
end
