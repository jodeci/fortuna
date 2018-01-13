# frozen_string_literal: true
class PayrollService
  attr_reader :payroll, :salary

  def initialize(payroll)
    @payroll = payroll
    @salary = payroll.find_salary
  end

  def run
    {
      name: payroll.employee.name,
      period: payment_period,
      filename: "#{payroll.employee.name} #{payment_period} 薪資明細",
      details: details_for_view,
      notes: notes,
      gain: sum_gain,
      loss: sum_loss,
      total: sum_gain - sum_loss,
    }
  end

  def gain
    cleanup(IncomeService.new(payroll, salary).send(payroll.employee.role))
  end

  def loss
    cleanup(DeductService.new(payroll, salary).send(payroll.employee.role))
  end

  private

  def notes
    PayrollNotesService.new(payroll).run
  end

  def sum_gain
    IncomeService.new(payroll, salary).total
  end

  def sum_loss
    DeductService.new(payroll, salary).total
  end

  def cleanup(hash)
    hash.delete_if { |_, v| v.zero? }
  end

  def details_for_view
    a1 = hash_to_array(gain)
    a2 = hash_to_array(loss)
    if a1.size > a2.size
      a2.fill(a2.size..a1.size - 1) { { "": nil } }
    else
      a1.fill(a1.size..a2.size - 1) { { "": nil } }
    end
    a1.zip(a2)
  end

  def hash_to_array(hash)
    array = []
    hash.map { |key, value| array << { "#{key}": value } }
    array
  end

  def payment_period
    "#{payroll.year}-#{sprintf('%02d', payroll.month)}"
  end
end
