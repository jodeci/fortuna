# frozen_string_literal: true
class StatementService
  attr_reader :statement, :payroll, :salary

  def initialize(payroll)
    @payroll = payroll
    @salary = payroll.salary
    @statement = Statement.find_or_initialize_by(payroll_id: payroll.id)
  end

  def build
    split? ? split_statement : build_statement
  end

  private

  def build_statement
    statement.update amount: total, year: payroll.year, month: payroll.month
  end

  def split_statement
    statement.update amount: split_base, year: payroll.year, month: payroll.month, splits: splits
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
    Rails.logger.info "payroll #{payroll.id}"
    salary.professional_service? and split_base > split_threshold
  end

  def total
    sum_gain - sum_loss
  end

  def sum_gain
    IncomeService.new(payroll, salary).total
  end

  def sum_loss
    DeductService.new(payroll, salary).total
  end

  def split_base
    sum_gain - DeductService.new(payroll, salary).before_withholdings
  end

  def split_threshold
    20000
  end
end
