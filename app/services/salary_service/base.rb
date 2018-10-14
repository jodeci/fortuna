# frozen_string_literal: true
# Salary 和 Payroll 是透過日期重疊的間接關聯，因此起薪日變動後需要補正與 Payroll 的關聯
module SalaryService
  class Base
    include Callable

    attr_reader :salary, :params

    def initialize(salary, params)
      @salary = salary
      @params = params
    end

    protected

    def effective_date
      Date.new(params["effective_date(1i)"].to_i, params["effective_date(2i)"].to_i, params["effective_date(3i)"].to_i)
    end

    def payrolls
      salary.employee.payrolls.details
    end

    # TODO: 只修正有影響到的部分
    def sync_payroll_relations
      payrolls.map { |payroll| SalaryService::SyncPayrollRelations.call(payroll) }
    end

    # TODO: 只修正有影響到的部分
    def sync_statements
      payrolls.map { |payroll| StatementService::Builder.call(payroll) }
    end
  end
end
