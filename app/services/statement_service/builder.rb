# frozen_string_literal: true
module StatementService
  class Builder
    include Callable
    include Calculatable

    attr_reader :statement, :payroll, :salary

    def initialize(payroll)
      @payroll = payroll
      @salary = payroll.salary
      @statement = Statement.find_or_create_by(payroll_id: payroll.id)
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
      @splits ||= StatementService::Splitter.call(payroll)
    end

    def unsplit_params
      {
        amount: total_income - total_deduction,
        year: payroll.year,
        month: payroll.month,
        splits: nil,
        subsidy_income: subsidy_income,
        excess_income: excess_income,
        gain: FormatService::Income.call(payroll),
        loss: FormatService::Deductions.call(payroll),
      }
    end

    def split_params
      {
        amount: splits.reduce(:+),
        year: payroll.year,
        month: payroll.month,
        splits: splits,
        subsidy_income: subsidy_income,
        excess_income: 0,
        # TODO: gain, loss 要保留 payroll 的原始項目
        gain: FormatService::Income.call(payroll),
        loss: FormatService::Deductions.call(payroll),
      }
    end
  end
end
