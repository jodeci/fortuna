# frozen_string_literal: true
module ReportService
  class OvertimeCell
    include Callable

    attr_reader :overtime, :employee

    def initialize(overtime)
      @overtime = overtime
      @employee = overtime.employee
    end

    def call
      {
        employee_id: employee.id,
        name: employee.name,
        period: period,
        description: "加班費",
        amount: CalculationService::Overtime.call(overtime),
        payroll_id: overtime.payroll_id,
      }
    end

    private

    def period
      "#{overtime.payroll_year}-#{sprintf('%02d', overtime.payroll_month)}"
    end
  end
end
