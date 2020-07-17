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
      Salary.find(SalaryTracker.salary_by_payroll(payroll: payroll))
    end
  end
end
