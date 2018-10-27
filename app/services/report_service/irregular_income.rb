# frozen_string_literal: true
module ReportService
  class IrregularIncome
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
      income_data.sort_by { |row| row[:period] }
    end

    def income_data
      vacation_refund + overtime + extra_entries
    end

    def vacation_refund
      Payroll.yearly_vacation_refunds(year).reduce([]) do |rows, payroll|
        rows << ReportService::VacationRefundCell.call(payroll)
      end
    end

    def overtime
      Overtime.yearly_report(year).reduce([]) do |rows, overtime|
        rows << ReportService::OvertimeCell.call(overtime)
      end
    end

    def extra_entries
      ExtraEntry.yearly_subsidy_report(year).reduce([]) do |rows, entry|
        rows << ReportService::ExtraEntryCell.call(entry)
      end
    end
  end
end
