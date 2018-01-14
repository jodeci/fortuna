# frozen_string_literal: true
class StatementService
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
      total: total,
    }
  end

  def sync
    statement = Statement.find_or_initialize_by(payroll_id: payroll.id)
    statement.update amount: total, year: payroll.year, month: payroll.month
  end

  private

  def gain
    cleanup(IncomeService.new(payroll, salary).send(payroll.employee.role))
  end

  def loss
    cleanup(DeductService.new(payroll, salary).send(payroll.employee.role))
  end

  def notes
    StatementNotesService.new(payroll).run
  end

  def sum_gain
    IncomeService.new(payroll, salary).total
  end

  def sum_loss
    DeductService.new(payroll, salary).total
  end

  def total
    sum_gain - sum_loss
  end

  def cleanup(hash)
    hash.delete_if { |_, value| value.zero? }
  end

  def details_for_view
    left = hash_to_array(gain)
    right = hash_to_array(loss)
    if left.size > right.size
      right.fill(right.size..left.size - 1) { { "": nil } }
    else
      left.fill(left.size..right.size - 1) { { "": nil } }
    end
    left.zip(right)
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
