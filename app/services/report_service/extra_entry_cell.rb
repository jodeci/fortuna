# frozen_string_literal: true
module ReportService
  class ExtraEntryCell
    include Callable

    attr_reader :entry, :payroll

    def initialize(entry)
      @entry = entry
      @payroll = entry.payroll
    end

    def call
      {
        employee_id: employee_id,
        name: name,
        period: period,
        description: entry.title,
        amount: entry.amount,
        payroll_id: payroll.id,
      }
    end

    private

    def employee_id
      payroll.employee_id
    end

    def name
      payroll.employee_name
    end

    def period
      "#{payroll.year}-#{sprintf('%02d', payroll.month)}"
    end
  end
end
