# frozen_string_literal: true
class StatementBuilderService
  attr_reader :payroll, :salary

  def initialize(payroll)
    @payroll = payroll
    @salary = payroll.find_salary
  end

  def run
    split? ? split_statements : build_statement
  end

  private

  def split?
    salary.professional_service? and salary.monthly_wage > threshold
  end

  def build_statement
    StatementService.new(payroll).sync
  end

  def split_statements
    # while income > threshold do
      # build statement #1: 開發費: 20000
      # build statement #2: 開發費: 20000
      # build statement #3: 開發費: 10000 + extras
    # end
  end

  def income
    # TODO: (monthly_wage * 不足月調整) + extra_gain - (leavetime + extra_loss)
    50000
  end

  def threshold
    20000
  end
end
