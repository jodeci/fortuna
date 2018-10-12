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
        rows << format_vacation_refund_cell(payroll)
      end
    end

    def overtime
      Overtime.yearly_report(year).reduce([]) do |rows, overtime|
        rows << format_overtime_cell(overtime)
      end
    end

    def extra_entries
      ExtraEntry.yearly_report(year).reduce([]) do |rows, entry|
        rows << format_extra_entry_cell(entry)
      end
    end

    def format_vacation_refund_cell(payroll)
      {
        employee_id: payroll.employee_id,
        name: payroll.employee.name,
        period: "#{year}-#{sprintf('%02d', payroll.month)}",
        description: "特休折現",
        amount: VacationRefundService.call(payroll),
        payroll_id: payroll.id,
      }
    end

    def format_overtime_cell(overtime)
      {
        employee_id: overtime.payroll.employee_id,
        name: overtime.payroll.employee.name,
        period: "#{year}-#{sprintf('%02d', overtime.payroll.month)}",
        description: "加班費",
        amount: OvertimeService.call(overtime),
        payroll_id: overtime.payroll_id,
      }
    end

    def format_extra_entry_cell(entry)
      {
        employee_id: entry.payroll.employee_id,
        name: entry.payroll.employee.name,
        period: "#{year}-#{sprintf('%02d', entry.payroll.month)}",
        description: entry.title,
        amount: entry.amount,
        payroll_id: entry.payroll_id,
      }
    end
  end
end
