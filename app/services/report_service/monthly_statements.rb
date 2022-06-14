# frozen_string_literal: true
module ReportService
  class MonthlyStatements
    include Callable

    attr_reader :year, :month

    def initialize(year, month)
      @year = year.to_i
      @month = month.to_i
    end

    def call
      generate_report
    end

    private

    def income_data
      @income_data ||= Report.salary_income_by_month(year, month).ordered.group_by(&:employee_id)
    end

    def generate_report
      {
        data: income_data.map { |row| format_row(row[1][0]) },
        gain_keys: base_keys(:gain),
        loss_keys: base_keys(:loss),
        gain_sum: sum(:gain),
        loss_sum: sum(:loss),
      }
    end

    def format_row(data)
      {
        name: data.name,
        gain: column_base(:gain).merge(data.gain),
        loss: column_base(:loss).merge(data.loss),
      }
    end

    def column_base(column)
      base_keys(column).index_with { |key| 0 }
    end

    def base_keys(column)
      income_data.inject([]) do |memo, row|
        memo += row[1][0].send(column).keys
        memo
      end.uniq
    end

    def sum(column)
      Report.column_by_month(year, month, column).inject { |a, b| a.merge(b) { |_, x, y| x + y } }
    end
  end
end
