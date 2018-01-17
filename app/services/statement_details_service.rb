# frozen_string_literal: true
class StatementDetailsService
  attr_reader :statement, :payroll, :salary

  def initialize(statement)
    @statement = statement
    @payroll = statement.payroll
    @salary = payroll.salary
  end

  def run
    statement.splits ? split : normal
  end

  def normal
    {
      name: payroll.employee.name,
      period: payment_period,
      filename: "#{payroll.employee.name} #{payment_period} 薪資明細",
      details: details_for_view,
      notes: notes,
      gain: sum_gain,
      loss: sum_loss,
      total: total,
      template: "statements/show",
    }
  end

  def split
    {
      name: payroll.employee.name,
      period: payment_period,
      filename: "#{payroll.employee.name} #{payment_period} 薪資明細",
      splits: statement.splits,
      notes: notes,
      total: statement.splits.reduce(:+),
      template: "statements/split",
    }
  end

  private

  def gain
    cleanup(IncomeService.new(payroll, salary).send(payroll.salary.role))
  end

  def loss
    cleanup(DeductService.new(payroll, salary).send(payroll.salary.role))
  end

  def notes
    StatementNotesService.new(payroll, salary).run
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
