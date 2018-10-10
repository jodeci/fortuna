# frozen_string_literal: true
class StatementService
  include Callable

  attr_reader :statement, :payroll, :salary

  def initialize(payroll)
    @payroll = payroll
    @salary = payroll.salary
    @statement = Statement.find_or_initialize_by(payroll_id: payroll.id)
  end

  def call
    statement.update(params)
  end

  private

  def params
    split? ? split_params : unsplit_params
  end

  def unsplit_params
    {
      amount: total,
      year: payroll.year,
      month: payroll.month,
      splits: nil,
      irregular_income: irregular_income,
    }
  end

  def split_params
    {
      amount: split_base,
      year: payroll.year,
      month: payroll.month,
      splits: splits,
      irregular_income: irregular_income,
    }
  end

  def splits
    ratio = split_base / split_threshold
    array = []
    ratio.times { array << split_threshold }
    array << split_base - ratio * split_threshold
    array.delete 0
    array
  end

  def split?
    return false if salary.regular_income?
    split_base > split_threshold
  end

  def irregular_income
    IncomeService.new(payroll).irregular
  end

  def total
    sum_gain - sum_loss
  end

  def sum_gain
    IncomeService.new(payroll).total
  end

  def sum_loss
    DeductService.new(payroll).total
  end

  def split_base
    sum_gain - DeductService.new(payroll).before_withholdings
  end

  # TODO: minimum_wage for parttime income
  def split_threshold
    20000
  end
end
