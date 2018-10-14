# frozen_string_literal: true
module StatementService
  class Builder
    include Callable
    include Calculatable

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
      split_statement? ? split_params : unsplit_params
    end

    def split_statement?
      return false if salary.regular_income?
      splits.present?
    end

    def splits
      StatementService::Splitter.call(payroll)
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
        amount: splits.reduce(:+),
        year: payroll.year,
        month: payroll.month,
        splits: splits,
        irregular_income: irregular_income,
      }
    end

    def irregular_income
      overtime + vacation_refund + payroll.taxfree_irregular_income
    end

    def total
      sum_gain - sum_loss
    end

    def sum_gain
      CalculationService::TotalIncome.call(payroll)
    end

    def sum_loss
      CalculationService::TotalDeduction.call(payroll)
    end
  end
end
