# frozen_string_literal: true
module ReportService
  class VacationRefundCell
    include Callable

    attr_reader :payroll

    def initialize(payroll)
      @payroll = payroll
    end

    def call
      {
        employee_id: payroll.employee_id,
        name: payroll.employee_name,
        period: period,
        description: "特休折現",
        amount: CalculationService::VacationRefund.call(payroll),
        payroll_id: payroll.id,
      }
    end

    private

    def period
      "#{payroll.year}-#{sprintf('%02d', payroll.month)}"
    end
  end
end
