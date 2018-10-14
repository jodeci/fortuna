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
      income_data.map { |row| format_row(row[1]) }
    end

    def income_data
      Report.salary_income(year).ordered.group_by(&:employee_id)
    end

    def format_row(data)
      {
        employee: format_employee(data.first),
        income: format_as_cells(data),
        festival_bonus: format_festival_bonus(data),
      }
    end

    def format_employee(data)
      {
        id: data.employee_id,
        name: data.name,
        id_number: data.id_number,
        address: data.residence_address,
      }
    end

    def format_as_cells(data)
      cells = []
      1.upto(12) { |month| cells << data.select { |cell| cell.month == month }.first }
      cells
    end

    def format_festival_bonus(data)
      hash = {}
      Payroll::FESTIVAL_BONUS.values.map do |festival_type|
        hash[festival_type.to_sym] = festival_bonus(data, festival_type)
      end
      hash
    end

    def festival_bonus(data, festival_type)
      match = data.select { |cell| cell.festival_type == festival_type }.first
      match ? match.festival_bonus : 0
    end
  end
end
