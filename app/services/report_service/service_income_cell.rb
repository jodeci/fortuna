# frozen_string_literal: true
module ReportService
  class ServiceIncomeCell
    include Callable

    attr_reader :data, :year, :month

    def initialize(data, year, month)
      @data = data
      @year = year
      @month = month
    end

    def call
      if month.zero?
        shift_to_previous_year
      else
        shift_to_previous_month
      end
    end

    private

    def shift_to_previous_year
      data.select { |cell| (cell.month == 12) && (cell.year == year - 1) }.first
    end

    def shift_to_previous_month
      data.select { |cell| cell.month == month }.first
    end
  end
end
