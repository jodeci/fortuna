# frozen_string_literal: true
class SalarySyncService
  include Callable

  attr_reader :employee, :salary, :params

  def initialize(employee, salary, params)
    @employee = employee
    @salary = salary
    @params = params
  end

  protected

  def effective_date
    Date.new(params["effective_date(1i)"].to_i, params["effective_date(2i)"].to_i, params["effective_date(3i)"].to_i)
  end

  def payrolls
    employee.payrolls.details
  end

  # Salary 和 Payroll 是透過日期重疊的間接關聯，因此起薪日變動後需要補正 Payroll
  def sync_payroll_relations
    payrolls.map do |payroll|
      matched_salary = payroll.find_salary
      payroll.update(salary: matched_salary) if matched_salary != payroll.salary
    end
  end

  def sync_statements
    payrolls.map { |payroll| StatementSyncService.call(payroll) }
  end
end
