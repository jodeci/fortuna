# frozen_string_literal: true
module ReportService
  class SalaryIncome
    include Callable

    attr_reader :year

    def initialize(year)
      @year = year.to_i
    end

    def call
      generate_report
    end

    private

    def generate_report
      income_data.map do |row|
        {
          employee: {
            id: row[1][0].employee_id,
            name: row[1][0].name,
          },
          income: format_as_cells(row[1]),
        }
      end
    end

    def income_data
      Report.salary_income(year).ordered.group_by(&:employee_id)
    end

    def format_as_cells(data)
      cells = []
      1.upto(12) { |month| cells << data.select { |cell| cell.month == month }.first }
      cells
    end
  end
end
