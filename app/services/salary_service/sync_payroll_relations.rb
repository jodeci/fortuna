# frozen_string_literal: true
module SalaryService
  class SyncPayrollRelations
    include Callable

    attr_reader :payroll

    def initialize(payroll)
      @payroll = payroll
    end

    def call
      payroll.update(salary: matched_salary) if matched_salary != payroll.salary
    end

    private

    def matched_salary
      @matched_salary ||= SalaryService::Finder.call(payroll.employee, cycle_start, cycle_end)
    end

    def cycle_start
      Date.new(payroll.year, payroll.month, 1)
    end

    def cycle_end
      Date.new(payroll.year, payroll.month, -1)
    end
  end
end
