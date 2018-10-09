# frozen_string_literal: true
class SalaryCreateService < SalarySyncService
  def call
    salary.save
    sync_payroll_relations if effective_date_backtrack?
    sync_statements
  end

  private

  def effective_date_backtrack?
    recent_salary.effective_date > effective_date
  end

  def recent_salary
    Salary.recent_for(employee)
  end
end
