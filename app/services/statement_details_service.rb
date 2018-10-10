# frozen_string_literal: true
class StatementDetailsService
  include Callable

  attr_reader :statement, :payroll, :salary

  def initialize(statement)
    @statement = statement
    @payroll = statement.payroll
    @salary = payroll.salary
  end

  def call
    statement.splits ? split : normal
  end

  private

  def normal
    {
      name: payroll.employee.name,
      period: payment_period,
      filename: "#{payment_period} 薪資明細-#{payroll.employee.name}",
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
      filename: "#{payment_period} 勞務報酬明細-#{payroll.employee.name}",
      splits: statement.splits,
      notes: notes,
      total: statement.splits.reduce(:+),
      template: "statements/split",
    }
  end

  def gain
    cleanup(IncomeService.new(payroll).send(salary.role))
  end

  def loss
    cleanup(DeductService.new(payroll).send(salary.role))
  end

  def notes
    StatementNotesService.call(payroll)
  end

  def sum_gain
    IncomeService.new(payroll).total
  end

  def sum_loss
    DeductService.new(payroll).total
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
